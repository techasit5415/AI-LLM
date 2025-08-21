#!/usr/bin/env python3
"""
สร้าง vector store ใหม่สำหรับ snake ด้วย chunk size ที่เล็กมาก
"""

import os
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain.embeddings.base import Embeddings
import hashlib

class UltraSimpleEmbeddings(Embeddings):
    """Simple hash-based embeddings สำหรับ chunks เล็ก ๆ"""
    def embed_documents(self, texts):
        embeddings = []
        for text in texts:
            # สร้าง embedding จาก hash ของข้อความ
            hash_obj = hashlib.md5(text.encode())
            hash_hex = hash_obj.hexdigest()
            # แปลง hex เป็น vector ขนาด 128 dimensions
            embedding = []
            for i in range(0, 32, 2):  # ใช้ 16 คู่ hex = 16 numbers
                embedding.append(int(hash_hex[i:i+2], 16) / 255.0)
            # เพิ่มเป็น 128 dimensions
            embedding = embedding * 8  # 16 * 8 = 128
            embeddings.append(embedding)
        return embeddings
    
    def embed_query(self, text):
        return self.embed_documents([text])[0]

def main():
    # อ่านไฟล์ snake data
    snake_file = "/home/techasit/Documents/Test/AI-LLM/data/sources/wikipedia_snake.txt"
    with open(snake_file, 'r', encoding='utf-8') as f:
        document = f.read()
    
    print(f"Document length: {len(document)} characters")
    
    # แบ่งเป็น chunks ขนาดเล็กมาก
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=150,    # เล็กมาก เพื่อป้องกัน context overflow
        chunk_overlap=20   # overlap น้อย
    )
    splits = splitter.split_text(document)
    splits = splitter.create_documents(splits)
    
    print(f"Number of chunks: {len(splits)}")
    
    # แสดงตัวอย่าง chunks
    for i in range(min(3, len(splits))):
        print(f"Chunk {i+1} ({len(splits[i].page_content)} chars): {splits[i].page_content[:50]}...")
    
    # สร้าง embeddings
    embeddings = UltraSimpleEmbeddings()
    
    # สร้าง FAISS vector store
    print("Creating FAISS vector store...")
    db = FAISS.from_documents(splits, embeddings)
    
    # ลบ vector store เก่า
    output_path = "/home/techasit/Documents/Test/AI-LLM/data/embeddings/vector store/snake"
    if os.path.exists(output_path + "/index.faiss"):
        os.remove(output_path + "/index.faiss")
    if os.path.exists(output_path + "/index.pkl"):
        os.remove(output_path + "/index.pkl")
    
    # บันทึก vector store ใหม่
    db.save_local(output_path)
    print(f"New snake vector store saved to: {output_path}")
    
    # ตรวจสอบขนาดไฟล์
    faiss_size = os.path.getsize(output_path + "/index.faiss")
    pkl_size = os.path.getsize(output_path + "/index.pkl")
    print(f"File sizes: index.faiss = {faiss_size} bytes, index.pkl = {pkl_size} bytes")
    
    # ทดสอบการค้นหา
    print("\nTesting search...")
    retriever = db.as_retriever(search_kwargs={"k": 2})  # ดึงแค่ 2 results
    results = retriever.get_relevant_documents("What are snakes?")
    
    print(f"Search results: {len(results)} documents")
    for i, doc in enumerate(results):
        print(f"Result {i+1}: {doc.page_content[:80]}...")

if __name__ == "__main__":
    main()
