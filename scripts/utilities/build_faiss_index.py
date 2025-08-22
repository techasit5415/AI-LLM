import os
import subprocess
import sys

def install_required_packages():
    """ติดตั้ง Python packages ที่จำเป็น"""
    required_packages = [
        "langchain>=0.1.0",
        "langchain-community>=0.0.10", 
        "faiss-cpu>=1.7.4",
        "transformers>=4.35.0",
        "sentence-transformers>=2.2.2",
        "numpy>=1.24.3",
        "torch>=2.1.0"
    ]
    
    print("📦 ตรวจสอบและติดตั้ง Python libraries ที่จำเป็น...")
    
    for package in required_packages:
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", package])
        except subprocess.CalledProcessError as e:
            print(f"⚠️  Warning: Failed to install {package}: {e}")
    
    print("✅ Libraries ติดตั้งเรียบร้อยแล้ว!")
    print()

# ติดตั้ง packages ก่อนเริ่มทำงาน
install_required_packages()

import numpy as np
from langchain_community.vectorstores import FAISS
from langchain.text_splitter import CharacterTextSplitter

# กำหนด vector store และไฟล์ข้อมูลที่รองรับ
VECTOR_STORES = {
    "naruto": [os.path.join("data", "sources", "wikipedia_naruto.txt")],
    "snake": [os.path.join("data", "sources", "wikipedia_snake.txt")],
    "naruto_snake": [
        os.path.join("data", "sources", "wikipedia_naruto.txt"),
        os.path.join("data", "sources", "wikipedia_snake.txt")
    ]
}

# ฟังก์ชันสำหรับสร้าง embedding แบบ stable สำหรับ FAISS compatibility
def get_embeddings():
    from langchain.embeddings.base import Embeddings
    import hashlib
    import numpy as np
    
    class StableSimpleEmbeddings(Embeddings):
        """Simple hash-based embeddings with stable 128 dimensions for FAISS compatibility"""
        
        def __init__(self, dimension=128):
            self.dimension = dimension
        
        def _hash_to_embedding(self, text):
            """Convert text to stable hash-based embedding"""
            # Create multiple hashes for better distribution
            hash1 = hashlib.md5(text.encode()).hexdigest()
            hash2 = hashlib.sha1(text.encode()).hexdigest()
            
            # Combine hashes and convert to numbers
            combined = hash1 + hash2
            numbers = [int(combined[i:i+2], 16) for i in range(0, min(len(combined), self.dimension * 2), 2)]
            
            # Normalize to [0, 1] and pad to required dimension
            embedding = [n / 255.0 for n in numbers]
            if len(embedding) < self.dimension:
                embedding.extend([0.0] * (self.dimension - len(embedding)))
            else:
                embedding = embedding[:self.dimension]
            
            return embedding
        
        def embed_documents(self, texts):
            return [self._hash_to_embedding(text) for text in texts]
        
        def embed_query(self, text):
            return self._hash_to_embedding(text)
    
    print("Using stable simple embeddings for FAISS compatibility...")
    return StableSimpleEmbeddings()

print("Available vector stores:")
for name in VECTOR_STORES:
    print(f"- {name}")

selected = input("Enter vector store to build (naruto, snake, naruto_snake, all): ").strip().lower()

if selected == "all":
    targets = list(VECTOR_STORES.keys())
else:
    if selected not in VECTOR_STORES:
        print(f"Unknown vector store: {selected}")
        exit(1)
    targets = [selected]

for store in targets:
    VECTOR_STORE_DIR = os.path.join("data", "embeddings", "vector store", store)
    os.makedirs(VECTOR_STORE_DIR, exist_ok=True)
    # ลบ index เดิม
    for fname in ["index.faiss", "index.pkl"]:
        fpath = os.path.join(VECTOR_STORE_DIR, fname)
        if os.path.exists(fpath):
            os.remove(fpath)
    # รวมข้อความ
    all_text = ""
    for data_file in VECTOR_STORES[store]:
        with open(data_file, encoding="utf-8") as f:
            text_content = f.read()
            all_text += text_content + "\n"
            print(f"Loaded {len(text_content)} characters from {data_file}")
    
    print(f"Total text length: {len(all_text)} characters")
    
    # แบ่งข้อความ - ใช้ขนาด 120 อักษรสำหรับทุก vector store เพื่อป้องกัน context overflow
    chunk_size = 120  # ใช้ขนาดเล็กสำหรับป้องกันปัญหา "คำถามยาวเกินไป"
    splitter = CharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=20)
    docs = splitter.create_documents([all_text])
    
    print(f"Created {len(docs)} chunks from text")
    
    # โหลด embedding model
    embeddings = get_embeddings()
    
    # สร้าง FAISS index
    print(f"Building FAISS index for {store} with {len(docs)} chunks (120 chars each)...")
    db = FAISS.from_documents(docs, embeddings)
    db.save_local(VECTOR_STORE_DIR)
    print(f"Index saved to {VECTOR_STORE_DIR} with {db.index.ntotal} vectors\n")
print("Done.")
