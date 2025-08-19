#!/bin/bash

# Model Download Script for LLM-RAG
# ดาวน์โหลด LLM models และ embedding models

set -e

echo "📥 กำลังดาวน์โหลด models สำหรับ LLM-RAG..."

# สร้าง directories
echo "📁 สร้าง model directories..."
mkdir -p ~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF
mkdir -p ~/Documents/AI/embedding-models

# ดาวน์โหลด LLM model
echo "🦙 ดาวน์โหลด Llama 3.2 3B Instruct GGUF..."
cd ~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF

if [[ ! -f "Llama-3.2-3B-Instruct-Q5_K_M.gguf" ]]; then
    echo "⬇️ กำลังดาวน์โหลด... (ขนาด ~2.16 GB)"
    wget -c https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf
    echo "✅ ดาวน์โหลด LLM model เสร็จแล้ว"
else
    echo "ℹ️ LLM model มีอยู่แล้ว"
fi

# ดาวน์โหลด embedding model (optional)
echo "🔤 ดาวน์โหลด embedding model..."
cd ~/Documents/AI/embedding-models

if [[ ! -d "all-MiniLM-L6-v2" ]]; then
    echo "⬇️ กำลังดาวน์โหลด sentence-transformers/all-MiniLM-L6-v2..."
    git clone https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2
    echo "✅ ดาวน์โหลด embedding model เสร็จแล้ว"
else
    echo "ℹ️ Embedding model มีอยู่แล้ว"
fi

# แสดงข้อมูล models ที่ดาวน์โหลด
echo ""
echo "📊 ข้อมูล models ที่ดาวน์โหลด:"
echo "LLM Model:"
ls -lh ~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/
echo ""
echo "Embedding Model:"
ls -lah ~/Documents/AI/embedding-models/

echo ""
echo "✅ ดาวน์โหลด models เสร็จสิ้น!"
echo ""
echo "📋 ขั้นตอนต่อไป:"
echo "1. ตรวจสอบ path ใน rag_chatbot.py:"
echo "   LLM path: ~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf"
echo "   Embedding path: ~/Documents/AI/embedding-models/all-MiniLM-L6-v2"
echo ""
echo "2. รัน application:"
echo "   cd /path/to/LLM-RAG"
echo "   source llm_rag_env/bin/activate"
echo "   streamlit run rag_chatbot.py"
