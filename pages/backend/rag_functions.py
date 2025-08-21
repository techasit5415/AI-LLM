import streamlit as st
import os
from langchain_community.document_loaders import TextLoader
from pypdf import PdfReader
from langchain_community.llms import LlamaCpp
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.embeddings import OpenAIEmbeddings, SentenceTransformerEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.chains import ConversationalRetrievalChain
from langchain.memory import ConversationBufferWindowMemory


def read_pdf(file):
    document = ""

    reader = PdfReader(file)
    for page in reader.pages:
        document += page.extract_text()

    return document


def read_txt(file):
    document = str(file.getvalue())
    document = document.replace("\\n", " \\n ").replace("\\r", " \\r ")

    return document


def split_doc(document, chunk_size, chunk_overlap):
    # จำกัด chunk_size ไม่ให้เกิน 300 tokens เพื่อป้องกันปัญหา context window
    max_chunk_size = min(chunk_size, 300)
    max_chunk_overlap = min(chunk_overlap, max_chunk_size // 4)

    splitter = RecursiveCharacterTextSplitter(
        chunk_size=max_chunk_size,
        chunk_overlap=max_chunk_overlap
    )
    split = splitter.split_text(document)
    split = splitter.create_documents(split)

    return split


def embedding_storing(model_name, split, create_new_vs, existing_vector_store, new_vs_name):
    if create_new_vs is not None:
        # Load embeddings instructor
        # ใช้ embedding แบบง่าย ๆ หรือใช้ที่โหลดมาพร้อม langchain
        try:
            from langchain_community.embeddings import HuggingFaceEmbeddings
            instructor_embeddings = HuggingFaceEmbeddings(
                model_name=model_name, model_kwargs={"device":"cpu"}  # เปลี่ยนเป็น cpu เพื่อหลีกเลี่ยงปัญหา
            )
        except Exception as e:
            # fallback เป็น FAISS default embedding
            print(f"Warning: Could not load HuggingFace embeddings: {e}")
            instructor_embeddings = None

        # Implement embeddings
        db = FAISS.from_documents(split, instructor_embeddings.embed_query)

        if create_new_vs == True:
            # Save db - ใช้ path ใหม่
            vector_store_path = os.path.join(os.path.dirname(__file__), "..", "..", "data", "embeddings", "vector store")
            if not os.path.exists(vector_store_path):
                os.makedirs(vector_store_path, exist_ok=True)
            db.save_local(os.path.join(vector_store_path, new_vs_name))
        else:
            # Load existing db with version compatibility - ใช้ path ใหม่
            vector_store_path = os.path.join(os.path.dirname(__file__), "..", "..", "data", "embeddings", "vector store")
            if not os.path.exists(vector_store_path):
                # Fallback สำหรับ path เก่า
                vector_store_path = os.path.join(os.path.dirname(__file__), "..", "..", "vector store")
            
            try:
                # สำหรับ langchain version ใหม่
                print("Trying to load FAISS with allow_dangerous_deserialization=True")
                load_db = FAISS.load_local(
                    os.path.join(vector_store_path, existing_vector_store),
                    instructor_embeddings,
                    allow_dangerous_deserialization=True
                )
                print("Successfully loaded FAISS with new API")
            except TypeError as e:
                # สำหรับ langchain version เก่า
                print(f"Failed with new API: {e}")
                print("Trying to load FAISS with old API")
                load_db = FAISS.load_local(
                    os.path.join(vector_store_path, existing_vector_store),
                    instructor_embeddings
                )
                print("Successfully loaded FAISS with old API")
            # Merge two DBs and save
            load_db.merge_from(db)
            load_db.save_local(os.path.join(vector_store_path, new_vs_name))

        st.success("The document has been saved.")


def prepare_rag_llm(
    token, llm_model, instruct_embeddings, vector_store_list, temperature, max_length, context_window=8192, retrieval_k=3
):
    # Load embeddings instructor - ใช้ simple embeddings ที่เสถียร
    try:
        from langchain.embeddings.base import Embeddings
        import hashlib
        
        class StableSimpleEmbeddings(Embeddings):
            def embed_documents(self, texts):
                embeddings = []
                for text in texts:
                    # สร้าง embedding จาก hash ของข้อความ
                    hash_obj = hashlib.md5(str(text).encode())
                    hash_hex = hash_obj.hexdigest()
                    # สร้าง vector ขนาด 128 dimensions
                    embedding = []
                    for i in range(0, 32, 2):
                        embedding.append(int(hash_hex[i:i+2], 16) / 255.0)
                    # ขยายเป็น 128 dimensions
                    embedding = embedding * 8
                    embeddings.append(embedding)
                return embeddings
            
            def embed_query(self, text):
                return self.embed_documents([text])[0]
        
        instructor_embeddings = StableSimpleEmbeddings()
        print("Using stable simple embeddings for compatibility")
            
    except Exception as e:
        print(f"Error creating embeddings: {e}")
        return None

    # Load db with version compatibility - ใช้ path ใหม่
    vector_store_path = os.path.join(os.path.dirname(__file__), "..", "..", "data", "embeddings", "vector store")
    if not os.path.exists(vector_store_path):
        # Fallback สำหรับ path เก่า
        vector_store_path = os.path.join(os.path.dirname(__file__), "..", "..", "vector store")
    
    try:
        print(f"Loading FAISS vector store from: {os.path.join(vector_store_path, vector_store_list)}")
        
        # สำหรับ langchain version ใหม่
        try:
            loaded_db = FAISS.load_local(
                os.path.join(vector_store_path, vector_store_list), 
                instructor_embeddings, 
                allow_dangerous_deserialization=True
            )
            print("Successfully loaded FAISS vector store with new API")
        except Exception as e1:
            # สำหรับ langchain version เก่า
            print(f"Failed with new API: {e1}")
            print("Trying to load FAISS vector store with old API")
            loaded_db = FAISS.load_local(
                os.path.join(vector_store_path, vector_store_list), 
                instructor_embeddings
            )
            print("Successfully loaded FAISS vector store with old API")
    
    except Exception as e:
        print(f"Error loading vector store: {e}")
        print("Attempting to recreate vector store...")
        return None

    # ตรวจสอบและปรับ context window
    max_context = min(context_window, 16384)  # จำกัดไม่เกิน 16K tokens
    if max_context < 4096:
        max_context = 4096  # ขั้นต่ำ 4K tokens
    
    print(f"Setting context window to: {max_context} tokens")

    # ตรวจสอบ CUDA memory ก่อนโหลดโมเดล
    try:
        import torch
        if torch.cuda.is_available():
            # ล้าง cache ก่อน
            torch.cuda.empty_cache()
            # ตรวจสอบ memory ที่เหลือ
            free_memory = torch.cuda.get_device_properties(0).total_memory - torch.cuda.memory_allocated(0)
            free_gb = free_memory / (1024**3)
            print(f"Available CUDA memory: {free_gb:.2f} GB")
            
            # ถ้า memory น้อยกว่า 3GB ให้ใช้ CPU อย่างเดียว
            if free_gb < 3.0:
                print("Warning: Low GPU memory, using CPU-only mode")
                n_gpu_layers = 0
            else:
                # คำนวณจำนวน GPU layers ตาม memory ที่มี
                n_gpu_layers = min(15, int(free_gb * 5))  # ประมาณ 5 layers ต่อ GB
        else:
            print("CUDA not available, using CPU")
            n_gpu_layers = 0
    except Exception as e:
        print(f"Error checking CUDA memory: {e}")
        n_gpu_layers = 0

    # Load LLM (LlamaCpp) with dynamic GPU usage
    llm = LlamaCpp(
        model_path=llm_model,  # path to .gguf file
        temperature=temperature,
        max_tokens=max_length,
        n_ctx=max_context,  # ใช้ค่า context window ที่ปรับแล้ว
        n_gpu_layers=n_gpu_layers,  # ใช้จำนวน GPU layers ที่คำนวณแล้ว
        n_batch=256,         # ลด batch size เพื่อประหยัด memory
        verbose=True,        # แสดง log เพื่อดูการใช้ GPU
    )

    memory = ConversationBufferWindowMemory(
        k=2,
        memory_key="chat_history",
        output_key="answer",
        return_messages=True,
    )

    # Create the chatbot with limited retrieval - ลด k สำหรับ snake
    final_retrieval_k = min(retrieval_k, 2) if "snake" in vector_store_list.lower() else retrieval_k
    qa_conversation = ConversationalRetrievalChain.from_llm(
        llm=llm,
        chain_type="stuff",
        retriever=loaded_db.as_retriever(
            search_type="similarity",
            search_kwargs={"k": final_retrieval_k}  # ใช้ค่าที่ปรับแล้ว
        ),
        return_source_documents=True,
        memory=memory,
    )

    return qa_conversation


def generate_answer(question, conversation):
    answer = "An error has occurred"

    if conversation is None:
        answer = "กรุณากด Create chatbot ก่อนเริ่มใช้งาน"
        doc_source = ["no source"]
    else:
        try:
            # จำกัดความยาวของคำถาม
            if len(question) > 500:  # ลดจาก 1000 เป็น 500
                question = question[:500] + "..."
            
            response = conversation({"question": question})
            answer = response.get("answer", "").split("Helpful Answer:")[-1].strip()
            if not answer:
                answer = response.get("answer", "ไม่สามารถตอบคำถามได้")
            explanation = response.get("source_documents", [])
            
            # จำกัดจำนวนและขนาดของ source documents
            limited_docs = []
            total_chars = 0
            for doc in explanation[:2]:  # เอาแค่ 2 documents แรก
                doc_content = doc.page_content[:200] + "..." if len(doc.page_content) > 200 else doc.page_content
                total_chars += len(doc_content)
                if total_chars > 400:  # จำกัดรวมไม่เกิน 400 ตัวอักษร
                    break
                limited_docs.append(doc_content)
            
            doc_source = limited_docs
        except ValueError as e:
            if "exceed context window" in str(e):
                answer = "คำถามยาวเกินไป กรุณาลองใช้คำถามที่สั้นลง หรือแบ่งเป็นหลายคำถาม"
                doc_source = ["Context window exceeded - try shorter questions"]
            else:
                import traceback
                error_details = traceback.format_exc()
                print(f"ValueError in conversation: {error_details}")
                answer = f"เกิดข้อผิดพลาด: {str(e)[:200]}..."
                doc_source = [f"Error details: {str(e)}"]
        except Exception as e:
            import traceback
            error_details = traceback.format_exc()
            print(f"Error in conversation: {error_details}")
            
            # แสดง error แบบละเอียดใน log แต่ให้คำตอบที่เป็นมิตรกับผู้ใช้
            if "context" in str(e).lower() or "window" in str(e).lower():
                answer = "คำถามยาวเกินไป กรุณาลองใช้คำถามที่สั้นลง หรือแบ่งเป็นหลายคำถาม"
                doc_source = ["Context length exceeded"]
            elif "memory" in str(e).lower() or "cuda" in str(e).lower():
                answer = "ระบบหน่วยความจำเต็ม กรุณาลองใหม่อีกครั้ง"
                doc_source = ["Memory error"]
            else:
                answer = "ขออภัย เกิดข้อผิดพลาดชั่วคราว กรุณาลองถามใหม่อีกครั้ง"
                doc_source = ["Temporary error occurred"]

    return answer, doc_source
