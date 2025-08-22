#!/usr/bin/env python3
"""
สร้าง vector store ใหม่สำหรับ naruto ด้วย compatibility ที่สมบูรณ์
"""

import os
import sys

# Get the project root directory (2 levels up from this script)
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(os.path.dirname(script_dir))
sys.path.append(project_root)

from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain.embeddings.base import Embeddings
import hashlib

class CompatibleEmbeddings(Embeddings):
    """Compatible embeddings ที่ทำงานได้กับ FAISS"""
    def embed_documents(self, texts):
        embeddings = []
        for text in texts:
            # สร้าง embedding จาก hash
            hash_obj = hashlib.md5(str(text).encode('utf-8'))
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

def main():
    try:
        # อ่านไฟล์ naruto data - ใช้ path ที่เป็น cross-platform
        naruto_file = os.path.join(project_root, "data", "sources", "wikipedia_naruto.txt")
        print(f"Reading file: {naruto_file}")
        
        with open(naruto_file, 'r', encoding='utf-8') as f:
            document = f.read()
        
        print(f"Document length: {len(document)} characters")
        
        # แบ่งเป็น chunks ขนาดเล็ก
        splitter = RecursiveCharacterTextSplitter(
            chunk_size=120,    # เล็กเหมือน snake
            chunk_overlap=15   # overlap น้อย
        )
        splits = splitter.split_text(document)
        splits = splitter.create_documents(splits)
        
        print(f"Number of chunks: {len(splits)}")
        
        # แสดงตัวอย่าง
        for i in range(min(3, len(splits))):
            print(f"Chunk {i+1}: {splits[i].page_content[:60]}...")
        
        # สร้าง embeddings
        embeddings = CompatibleEmbeddings()
        print("Testing embeddings...")
        test_embed = embeddings.embed_query("test")
        print(f"Embedding dimension: {len(test_embed)}")
        
        # สร้าง FAISS vector store
        print("Creating FAISS vector store...")
        db = FAISS.from_documents(splits, embeddings)
        
        # ลบไฟล์เก่า
        output_path = os.path.join(project_root, "data", "embeddings", "vector store", "naruto")
        os.makedirs(output_path, exist_ok=True)
        
        for fname in ["index.faiss", "index.pkl"]:
            fpath = os.path.join(output_path, fname)
            if os.path.exists(fpath):
                os.remove(fpath)
                print(f"Removed old file: {fname}")
        
        # บันทึก vector store ใหม่
        db.save_local(output_path)
        print(f"New naruto vector store saved to: {output_path}")
        
        # ตรวจสอบขนาดไฟล์
        faiss_size = os.path.getsize(os.path.join(output_path, "index.faiss"))
        pkl_size = os.path.getsize(os.path.join(output_path, "index.pkl"))
        print(f"File sizes: index.faiss = {faiss_size} bytes, index.pkl = {pkl_size} bytes")
        
        # ทดสอบการโหลดและค้นหา
        print("\nTesting load and search...")
        test_embeddings = CompatibleEmbeddings()
        
        # ทดสอบโหลด
        try:
            test_db = FAISS.load_local(output_path, test_embeddings, allow_dangerous_deserialization=True)
            print("✅ Successfully loaded vector store")
            
            # ทดสอบค้นหา
            retriever = test_db.as_retriever(search_kwargs={"k": 2})
            results = retriever.get_relevant_documents("What is Naruto?")
            
            print(f"✅ Search successful: {len(results)} results")
            for i, doc in enumerate(results):
                print(f"  Result {i+1}: {doc.page_content[:50]}...")
                
        except Exception as e:
            print(f"❌ Test failed: {e}")
            return False
        
        print("\n🎉 Naruto vector store successfully created and tested!")
        return True
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
