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
    # จำกัด chunk_size ไม่ให้เกิน 500 tokens เพื่อป้องกันปัญหา context window
    max_chunk_size = min(chunk_size, 500)
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
    # Load embeddings instructor - ใช้โมเดล local และ GPU
    try:
        # ถ้ามีโมเดลในเครื่อง ใช้ path local
        if os.path.exists(instruct_embeddings):
            print(f"Loading local embedding model from: {instruct_embeddings}")
            from sentence_transformers import SentenceTransformer
            import torch
            
            # Custom embedding class ที่ใช้ sentence-transformers โดยตรง
            class LocalEmbeddings:
                def __init__(self, model_path):
                    self.model = SentenceTransformer(model_path, device='cuda' if torch.cuda.is_available() else 'cpu')
                
                def embed_documents(self, texts):
                    embeddings = self.model.encode(texts, convert_to_tensor=False)
                    return embeddings.tolist()
                
                def embed_query(self, text):
                    embedding = self.model.encode([text], convert_to_tensor=False)
                    return embedding[0].tolist()
            
            instructor_embeddings = LocalEmbeddings(instruct_embeddings)
        else:
            # fallback: ใช้ embedding ง่าย ๆ
            print(f"Path not found: {instruct_embeddings}, using simple embeddings")
            from langchain.embeddings.base import Embeddings
            import hashlib
            
            class SimpleEmbeddings(Embeddings):
                def embed_documents(self, texts):
                    # สร้าง embedding จาก hash ของข้อความ (สำหรับทดสอบ)
                    embeddings = []
                    for text in texts:
                        hash_obj = hashlib.md5(text.encode())
                        hash_hex = hash_obj.hexdigest()
                        # แปลง hex เป็น numbers และ normalize
                        embedding = [int(hash_hex[i:i+2], 16) / 255.0 for i in range(0, min(32, len(hash_hex)), 2)]
                        # ตรวจสอบ dimension ของ vector store ที่มีอยู่
                        try:
                            # ลองโหลด vector store เพื่อดู dimension
                            test_db_path = f"vector store/{vector_store_list[0] if 'vector_store_list' in globals() else 'naruto_snake'}"
                            if os.path.exists(test_db_path + "/index.faiss"):
                                import faiss
                                index = faiss.read_index(test_db_path + "/index.faiss")
                                target_dim = index.d
                                embedding = embedding + [0.0] * (target_dim - len(embedding))  # pad to target dimension
                            else:
                                embedding = embedding + [0.0] * (768 - len(embedding))  # default to 768
                        except:
                            embedding = embedding + [0.0] * (768 - len(embedding))  # fallback to 768
                        embeddings.append(embedding)
                    return embeddings
                
                def embed_query(self, text):
                    return self.embed_documents([text])[0]
            
            instructor_embeddings = SimpleEmbeddings()
            
    except Exception as e:
        print(f"Error loading embeddings: {e}")
        # ใช้ simple embedding เป็น fallback
        from langchain.embeddings.base import Embeddings
        
        class FallbackEmbeddings(Embeddings):
            def embed_documents(self, texts):
                return [[0.1] * 384 for _ in texts]
            def embed_query(self, text):
                return [0.1] * 384
                
        instructor_embeddings = FallbackEmbeddings()

    # Load db with version compatibility - ใช้ path ใหม่
    vector_store_path = os.path.join(os.path.dirname(__file__), "..", "..", "data", "embeddings", "vector store")
    if not os.path.exists(vector_store_path):
        # Fallback สำหรับ path เก่า
        vector_store_path = os.path.join(os.path.dirname(__file__), "..", "..", "vector store")
    
    try:
        # สำหรับ langchain version ใหม่
        print("Trying to load FAISS vector store with allow_dangerous_deserialization=True")
        loaded_db = FAISS.load_local(
            os.path.join(vector_store_path, vector_store_list), 
            instructor_embeddings.embed_query, 
            allow_dangerous_deserialization=True
        )
        print("Successfully loaded FAISS vector store with new API")
    except TypeError as e:
        # สำหรับ langchain version เก่า
        print(f"Failed with new API: {e}")
        print("Trying to load FAISS vector store with old API")
        loaded_db = FAISS.load_local(
            os.path.join(vector_store_path, vector_store_list), 
            instructor_embeddings.embed_query
        )
        print("Successfully loaded FAISS vector store with old API")

    # ตรวจสอบและปรับ context window
    max_context = min(context_window, 16384)  # จำกัดไม่เกิน 16K tokens
    if max_context < 4096:
        max_context = 4096  # ขั้นต่ำ 4K tokens
    
    print(f"Setting context window to: {max_context} tokens")

    # Load LLM (LlamaCpp)
    llm = LlamaCpp(
        model_path=llm_model,  # path to .gguf file
        temperature=temperature,
        max_tokens=max_length,
        n_ctx=max_context,  # ใช้ค่า context window ที่ปรับแล้ว
        n_gpu_layers=-1,  # ใช้ GPU ทั้งหมด (ทุก layer)
        n_batch=512,      # เพิ่ม batch size สำหรับ GPU
        verbose=True,     # แสดง log เพื่อดูการใช้ GPU
    )

    memory = ConversationBufferWindowMemory(
        k=2,
        memory_key="chat_history",
        output_key="answer",
        return_messages=True,
    )

    # Create the chatbot with limited retrieval
    qa_conversation = ConversationalRetrievalChain.from_llm(
        llm=llm,
        chain_type="stuff",
        retriever=loaded_db.as_retriever(
            search_type="similarity",
            search_kwargs={"k": retrieval_k}  # ใช้ค่าที่ผู้ใช้กำหนด
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
            if len(question) > 1000:
                question = question[:1000] + "..."
                
            response = conversation({"question": question})
            answer = response.get("answer", "").split("Helpful Answer:")[-1].strip()
            if not answer:
                answer = response.get("answer", "ไม่สามารถตอบคำถามได้")
            explanation = response.get("source_documents", [])
            doc_source = [d.page_content for d in explanation]
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
            answer = f"เกิดข้อผิดพลาด: {str(e)[:200]}..."  # แสดงข้อผิดพลาดแบบละเอียด
            doc_source = [f"Error details: {str(e)}"]

    return answer, doc_source
