#!/usr/bin/env python3
"""
Script เพื่อแก้ไขปัญหา FAISS compatibility 
และทดสอบการโหลด vector store
"""

import os
import sys

def test_faiss_loading():
    """ทดสอบการโหลด FAISS vector store"""
    
    print("🔍 Testing FAISS vector store loading...")
    
    try:
        from langchain_community.vectorstores import FAISS
        from langchain_community.embeddings import SentenceTransformerEmbeddings
        print("✅ Successfully imported FAISS and SentenceTransformerEmbeddings")
    except ImportError as e:
        print(f"❌ Import error: {e}")
        return False
    
    # ทดสอบ embedding
    try:
        print("🔤 Testing embedding model...")
        embeddings = SentenceTransformerEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
        test_embed = embeddings.embed_query("test")
        print(f"✅ Embedding working, dimension: {len(test_embed)}")
    except Exception as e:
        print(f"❌ Embedding error: {e}")
        return False
    
    # ทดสอบ FAISS loading
    vector_stores = ["naruto", "snake", "naruto_snake"]
    
    for vs_name in vector_stores:
        vs_path = f"vector store/{vs_name}"
        if os.path.exists(vs_path):
            print(f"\n📁 Testing vector store: {vs_name}")
            
            try:
                # ลอง API ใหม่ก่อน
                try:
                    db = FAISS.load_local(
                        vs_path, 
                        embeddings, 
                        allow_dangerous_deserialization=True
                    )
                    print(f"✅ {vs_name}: Loaded with NEW API (allow_dangerous_deserialization=True)")
                except TypeError:
                    # ถ้าไม่ได้ ลอง API เก่า
                    db = FAISS.load_local(vs_path, embeddings)
                    print(f"✅ {vs_name}: Loaded with OLD API (no allow_dangerous_deserialization)")
                
                # ทดสอบ search
                results = db.similarity_search("test query", k=1)
                print(f"   📖 Found {len(results)} documents")
                
            except Exception as e:
                print(f"❌ {vs_name}: Failed to load - {e}")
        else:
            print(f"⚠️ Vector store not found: {vs_path}")
    
    return True

def check_versions():
    """ตรวจสอบ version ของ packages ที่เกี่ยวข้อง"""
    
    print("\n📋 Checking package versions:")
    
    packages = [
        "langchain",
        "langchain-community", 
        "faiss-cpu",
        "sentence-transformers",
        "streamlit"
    ]
    
    for package in packages:
        try:
            if package == "langchain":
                import langchain
                print(f"   {package}: {langchain.__version__}")
            elif package == "langchain-community":
                import langchain_community
                print(f"   {package}: {langchain_community.__version__}")
            elif package == "faiss-cpu":
                import faiss
                print(f"   {package}: available")
            elif package == "sentence-transformers":
                import sentence_transformers
                print(f"   {package}: {sentence_transformers.__version__}")
            elif package == "streamlit":
                import streamlit
                print(f"   {package}: {streamlit.__version__}")
        except ImportError:
            print(f"   {package}: ❌ Not installed")
        except AttributeError:
            print(f"   {package}: ✅ Installed (version unknown)")

def main():
    print("🔧 FAISS Compatibility Fixer")
    print("=" * 50)
    
    # ตรวจสอบว่าอยู่ใน project directory
    if not os.path.exists("rag_chatbot.py"):
        print("❌ Please run this script from the LLM-RAG project directory")
        return
    
    # ตรวจสอบ versions
    check_versions()
    
    # ทดสอบ FAISS loading
    success = test_faiss_loading()
    
    if success:
        print("\n✅ FAISS compatibility test completed!")
        print("   The rag_functions.py has been updated to handle both old and new FAISS APIs")
    else:
        print("\n❌ There are still issues with FAISS loading")
        print("   You may need to update your packages:")
        print("   pip install --upgrade langchain langchain-community faiss-cpu")

if __name__ == "__main__":
    main()
