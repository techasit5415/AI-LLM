#!/bin/bash

# Python Environment Setup Script for LLM-RAG
# รันหลังจากติดตั้ง system dependencies แล้ว

set -e

echo "🐍 กำลังตั้งค่า Python environment สำหรับ LLM-RAG..."

# ตรวจสอบว่าอยู่ใน project directory
if [[ ! -f "requirements.txt" ]]; then
    echo "❌ ไม่พบไฟล์ requirements.txt"
    echo "   กรุณา cd เข้าไปใน LLM-RAG directory ก่อน"
    exit 1
fi

# สร้าง virtual environment
echo "📦 สร้าง virtual environment..."
if [[ ! -d "llm_rag_env" ]]; then
    python3 -m venv llm_rag_env
    echo "✅ สร้าง virtual environment เสร็จแล้ว"
else
    echo "ℹ️ virtual environment มีอยู่แล้ว"
fi

# เปิดใช้งาน virtual environment
echo "🔄 เปิดใช้งาน virtual environment..."
source llm_rag_env/bin/activate

# อัพเกรด pip
echo "⬆️ อัพเกรด pip..."
pip install --upgrade pip

# ติดตั้ง basic packages ก่อน
echo "📦 ติดตั้ง basic packages..."
pip install wheel setuptools

# ติดตั้ง PyTorch ก่อน (เพื่อหลีกเลี่ยง conflict)
echo "🔥 ติดตั้ง PyTorch..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# ติดตั้ง packages อื่นๆ
echo "📦 ติดตั้ง packages จาก requirements.txt..."
pip install streamlit==1.29.0
pip install langchain==0.1.0 langchain-community==0.0.10
pip install faiss-cpu==1.7.4
pip install sentence-transformers==2.2.2
pip install pypdf==3.17.4 python-docx==1.1.0
pip install tiktoken==0.5.2
pip install numpy==1.24.3 pandas==2.0.3
pip install requests==2.31.0 beautifulsoup4==4.12.2 lxml==4.9.3
pip install Pillow==10.1.0 python-dotenv==1.0.0

# ติดตั้ง llama-cpp-python พร้อม CUDA support
echo "🦙 ติดตั้ง llama-cpp-python พร้อม CUDA support..."
pip uninstall -y llama-cpp-python || true
CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python==0.2.90 --no-cache-dir

echo "✅ Python environment setup เสร็จสิ้น!"
echo ""
echo "📋 ขั้นตอนต่อไป:"
echo "1. ดาวน์โหลด LLM model:"
echo "   cd ~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF"
echo "   wget https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf"
echo ""
echo "2. ตรวจสอบ path ในไฟล์ rag_chatbot.py (บรรทัด 46)"
echo ""
echo "3. รัน application:"
echo "   source llm_rag_env/bin/activate  # หากยังไม่ได้เปิดใช้งาน"
echo "   streamlit run rag_chatbot.py"
echo ""
echo "🎉 พร้อมใช้งาน!"
