#!/usr/bin/env python3
"""
สคริปต์สำหรับสร้าง vector store ใหม่สำหรับ snake data ด้วย chunk size ที่เล็กลง
"""

import os
import sys
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import HuggingFaceEmbeddings

def read_text_file(file_path):
    """อ่านไฟล์ text"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return f.read()

def split_doc_small(document, chunk_size=200, chunk_overlap=50):
    """แบ่งเอกสารเป็น chunks ขนาดเล็ก"""
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap
    )
    split = splitter.split_text(document)
    split = splitter.create_documents(split)
    return split

def main():
    # ตรวจสอบไฟล์ source
    snake_file = "/home/techasit/Documents/Test/AI-LLM/data/sources/wikipedia_snake.txt"
    if not os.path.exists(snake_file):
        print(f"ไม่พบไฟล์: {snake_file}")
        return
    
    print("อ่านไฟล์ snake data...")
    document = read_text_file(snake_file)
    print(f"ความยาวเอกสาร: {len(document)} ตัวอักษร")
    
    print("แบ่งเอกสารเป็น chunks ขนาดเล็ก...")
    splits = split_doc_small(document, chunk_size=200, chunk_overlap=50)
    print(f"จำนวน chunks: {len(splits)}")
    
    # แสดง chunk แรกเพื่อตรวจสอบ
    if splits:
        print(f"ตัวอย่าง chunk แรก: {splits[0].page_content[:100]}...")
    
    print("สร้าง embeddings...")
    try:
        # ใช้ embedding model ที่เบา
        from langchain_community.embeddings import HuggingFaceEmbeddings
        embeddings = HuggingFaceEmbeddings(
            model_name="sentence-transformers/all-MiniLM-L6-v2",
            model_kwargs={"device": "cpu"}
        )
    except Exception as e:
        print(f"ไม่สามารถโหลด HuggingFace embeddings: {e}")
        print("ใช้ OpenAI-compatible embeddings แทน...")
        try:
            from langchain_community.embeddings import SentenceTransformerEmbeddings
            embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
        except Exception as e2:
            print(f"ไม่สามารถโหลด SentenceTransformer embeddings: {e2}")
            print("ใช้ simple hash-based embeddings...")
            
            from langchain.embeddings.base import Embeddings
            import hashlib
            
            class SimpleEmbeddings(Embeddings):
                def embed_documents(self, texts):
                    embeddings = []
                    for text in texts:
                        hash_obj = hashlib.md5(text.encode())
                        hash_hex = hash_obj.hexdigest()
                        embedding = [int(hash_hex[i:i+2], 16) / 255.0 for i in range(0, 32, 2)]
                        embedding = embedding + [0.0] * (384 - len(embedding))
                        embeddings.append(embedding)
                    return embeddings
                
                def embed_query(self, text):
                    return self.embed_documents([text])[0]
            
            embeddings = SimpleEmbeddings()
    
    print("สร้าง FAISS vector store...")
    db = FAISS.from_documents(splits, embeddings)
    
    # บันทึก vector store ใหม่
    output_path = "/home/techasit/Documents/Test/AI-LLM/data/embeddings/vector store/snake"
    os.makedirs(output_path, exist_ok=True)
    
    print(f"บันทึก vector store ที่: {output_path}")
    db.save_local(output_path)
    
    print("สร้าง snake vector store ใหม่เสร็จสิ้น!")
    print("ลองทดสอบการค้นหา...")
    
    # ทดสอบการค้นหา
    retriever = db.as_retriever(search_kwargs={"k": 3})
    results = retriever.get_relevant_documents("What are snakes?")
    
    print(f"ผลการค้นหา: {len(results)} documents")
    for i, doc in enumerate(results):
        print(f"Document {i+1}: {doc.page_content[:100]}...")

if __name__ == "__main__":
    main()
