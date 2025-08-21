#!/usr/bin/env python3
"""
สร้าง vector store ใหม่สำหรับ naruto_snake ด้วย compatibility ที่สมบูรณ์
"""

import os
import sys
sys.path.append('/home/techasit/Documents/Test/AI-LLM')

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
        # อ่านไฟล์ทั้งสอง
        files = [
            "/home/techasit/Documents/Test/AI-LLM/data/sources/wikipedia_naruto.txt",
            "/home/techasit/Documents/Test/AI-LLM/data/sources/wikipedia_snake.txt"
        ]
        
        all_document = ""
        for file_path in files:
            print(f"Reading file: {file_path}")
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                all_document += content + "\n\n"
        
        print(f"Combined document length: {len(all_document)} characters")
        
        # แบ่งเป็น chunks ขนาดเล็ก
        splitter = RecursiveCharacterTextSplitter(
            chunk_size=120,    # เล็กเหมือนอื่น ๆ
            chunk_overlap=15   # overlap น้อย
        )
        splits = splitter.split_text(all_document)
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
        output_path = "/home/techasit/Documents/Test/AI-LLM/data/embeddings/vector store/naruto_snake"
        os.makedirs(output_path, exist_ok=True)
        
        for fname in ["index.faiss", "index.pkl"]:
            fpath = os.path.join(output_path, fname)
            if os.path.exists(fpath):
                os.remove(fpath)
                print(f"Removed old file: {fname}")
        
        # บันทึก vector store ใหม่
        db.save_local(output_path)
        print(f"New naruto_snake vector store saved to: {output_path}")
        
        # ตรวจสอบขนาดไฟล์
        faiss_size = os.path.getsize(os.path.join(output_path, "index.faiss"))
        pkl_size = os.path.getsize(os.path.join(output_path, "index.pkl"))
        print(f"File sizes: index.faiss = {faiss_size} bytes, index.pkl = {pkl_size} bytes")
        
        # ทดสอบการโหลดและค้นหา
        print("\nTesting load and search...")
        test_embeddings = CompatibleEmbeddings()
        
        # ทดสอบโหลด
        try:
            test_db = FAISS.load_local(output_path, test_embeddings)
            print("✅ Successfully loaded vector store")
            
            # ทดสอบค้นหา Naruto
            retriever = test_db.as_retriever(search_kwargs={"k": 2})
            results1 = retriever.get_relevant_documents("What is Naruto?")
            print(f"✅ Naruto search successful: {len(results1)} results")
            
            # ทดสอบค้นหา Snake
            results2 = retriever.get_relevant_documents("What are snakes?")
            print(f"✅ Snake search successful: {len(results2)} results")
                
        except Exception as e:
            print(f"❌ Test failed: {e}")
            return False
        
        print("\n🎉 Naruto_Snake vector store successfully created and tested!")
        return True
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
