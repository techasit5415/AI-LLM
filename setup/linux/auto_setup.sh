#!/bin/bash

# LLM-RAG Auto Setup Script
# สำหรับติดตั้งระบบ RAG Chatbot แบบ Local LLM

set -e  # หยุดทำงานหากมี error

echo "🚀 เริ่มติดตั้ง LLM-RAG Chatbot System..."

# ตรวจสอบ OS
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "❌ รองรับเฉพาะ Linux เท่านั้น"
    exit 1
fi

# ตรวจสอบสิทธิ์ sudo
if ! sudo -v; then
    echo "❌ ต้องการสิทธิ์ sudo"
    exit 1
fi

echo "📦 กำลังติดตั้ง system dependencies..."

# Update package list
sudo apt update

# CUDA และ build tools
echo "🔧 ติดตั้ง CUDA และ build tools..."
sudo apt install -y nvidia-cuda-toolkit build-essential cmake git wget curl

# Python development
echo "🐍 ติดตั้ง Python development tools..."
sudo apt install -y python3-dev python3-pip python3-venv

# ML/AI libraries
echo "🧮 ติดตั้ง ML/AI system libraries..."
sudo apt install -y libblas-dev liblapack-dev libopenblas-dev gfortran

# Graphics และ multimedia
echo "🎨 ติดตั้ง graphics และ multimedia libraries..."
sudo apt install -y libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev libgomp1

# PDF และ media processing
echo "📄 ติดตั้ง document และ media processing tools..."
sudo apt install -y poppler-utils ffmpeg libsndfile1

# Utilities
echo "🛠️ ติดตั้ง utilities..."
sudo apt install -y htop tree unzip

echo "✅ System dependencies ติดตั้งเสร็จแล้ว!"

# ตรวจสอบ NVIDIA
echo "🔍 ตรวจสอบ NVIDIA GPU..."
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi
    echo "✅ NVIDIA GPU พบแล้ว"
else
    echo "⚠️ ไม่พบ NVIDIA driver หรือ GPU"
    echo "   รัน: sudo apt install -y nvidia-driver-535 && sudo reboot"
fi

# ตรวจสอบ CUDA
echo "🔍 ตรวจสอบ CUDA..."
if command -v nvcc &> /dev/null; then
    nvcc --version
    echo "✅ CUDA พบแล้ว"
else
    echo "⚠️ CUDA ไม่พบ หรือไม่ได้อยู่ใน PATH"
fi

# สร้าง directory structure
echo "📁 สร้าง directory structure..."
mkdir -p ~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF
mkdir -p ~/Documents/AI/embedding-models

# เตรียม environment variables
echo "🔧 ตั้งค่า environment variables..."
grep -qxF 'export CUDA_VISIBLE_DEVICES=0' ~/.bashrc || echo 'export CUDA_VISIBLE_DEVICES=0' >> ~/.bashrc
grep -qxF 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' ~/.bashrc || echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' >> ~/.bashrc

echo "🎉 System setup เสร็จสิ้น!"
echo ""
echo "📋 ขั้นตอนต่อไป:"
echo "1. รัน: source ~/.bashrc"
echo "2. สร้าง virtual environment: python3 -m venv llm_rag_env"
echo "3. เปิดใช้งาน: source llm_rag_env/bin/activate"
echo "4. ติดตั้ง Python packages: pip install -r requirements.txt"
echo "5. ติดตั้ง llama-cpp-python พร้อม CUDA: CMAKE_ARGS=\"-DLLAMA_CUBLAS=on\" pip install llama-cpp-python==0.2.90"
echo "6. ดาวน์โหลด LLM model (ดูใน SETUP_GUIDE.md)"
echo "7. รัน: streamlit run rag_chatbot.py"
echo ""
echo "📖 อ่านคู่มือเต็มใน SETUP_GUIDE.md"
