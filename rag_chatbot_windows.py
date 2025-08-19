# สร้างไฟล์ rag_chatbot_windows.py สำหรับ Windows
# โดยแก้ไข path ให้เป็น Windows format

import streamlit as st
import os
from pages.backend import rag_functions


st.title("RAG Chatbot")

# Setting the LLM
with st.expander("Setting the LLM"):
    st.markdown("This page is used to have a chat with the uploaded documents")
    with st.form("setting"):
        row_1 = st.columns(3)
        with row_1[0]:
            token = st.text_input("Hugging Face Token", type="password")

        with row_1[1]:
            llm_model = st.text_input("LLM model", value="tiiuae/falcon-7b-instruct")

        with row_1[2]:
            instruct_embeddings = st.text_input("Instruct Embeddings", value="hkunlp/instructor-base")

            # Static path สำหรับ embedding model (Windows format)
            local_embed_path = r"C:\AI\embedding-models\all-MiniLM-L6-v2"
            if os.path.exists(local_embed_path):
                instruct_embeddings = local_embed_path
            else:
                instruct_embeddings = "sentence-transformers/all-MiniLM-L6-v2"

        row_2 = st.columns(3)
        with row_2[0]:
            vector_store_path = os.path.join(os.path.dirname(__file__), "data", "embeddings", "vector store")
            if os.path.exists(vector_store_path):
                vector_store_list = os.listdir(vector_store_path)
            else:
                # Fallback สำหรับ path เก่า
                vector_store_path = os.path.join(os.path.dirname(__file__), "vector store")
                vector_store_list = os.listdir(vector_store_path) if os.path.exists(vector_store_path) else []
                
            default_choice = (
                vector_store_list.index('naruto_snake')
                if 'naruto_snake' in vector_store_list
                else 0
            ) if vector_store_list else 0
            existing_vector_store = st.selectbox("Vector Store", vector_store_list, default_choice)
        
        with row_2[1]:
            temperature = st.number_input("Temperature", value=1.0, step=0.1)

        with row_2[2]:
            max_length = st.number_input("Max Length", value=512, step=1)

        # Static path สำหรับ LLM .gguf (Windows format)
        llm_model = r"C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf"

        token = ""  # ไม่ต้องใช้ HuggingFace Token
        create_chatbot = st.form_submit_button("Create chatbot")



# Prepare the LLM model
if "conversation" not in st.session_state:
    st.session_state.conversation = None

if create_chatbot:
    st.session_state.conversation = rag_functions.prepare_rag_llm(
        token, llm_model, instruct_embeddings, existing_vector_store, temperature, max_length
    )

# Chat history
if "history" not in st.session_state:
    st.session_state.history = []

# Source documents
if "source" not in st.session_state:
    st.session_state.source = []

# Display chats
for message in st.session_state.history:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Ask a question
if question := st.chat_input("Ask a question"):
    # Append user question to history
    st.session_state.history.append({"role": "user", "content": question})
    # Add user question
    with st.chat_message("user"):
        st.markdown(question)


    # ตอบคำถามด้วย RAG conversation ที่สร้างไว้
    if st.session_state.conversation:
        answer, doc_source = rag_functions.generate_answer(question, st.session_state.conversation)
    else:
        answer, doc_source = "กรุณากด Create chatbot ก่อนเริ่มใช้งาน", ["no source"]

    with st.chat_message("assistant"):
        st.write(answer)
    # Append assistant answer to history
    st.session_state.history.append({"role": "assistant", "content": answer})

    # Append the document sources
    st.session_state.source.append({"question": question, "answer": answer, "document": doc_source})


# Source documents
with st.expander("Source documents"):
    st.write(st.session_state.source)
