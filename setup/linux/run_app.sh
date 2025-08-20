#!/bin/bash

# Linux Run Application Script
# รัน LLM-RAG Chatbot บน Linux

echo "🚀 เริ่มต้น LLM-RAG Chatbot บน Linux..."

# เปลี่ยนไปยัง project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$PROJECT_DIR"

# ตรวจสอบว่าอยู่ใน project directory
if [[ ! -f "rag_chatbot.py" ]]; then
    echo "❌ ไม่พบไฟล์ rag_chatbot.py ใน $PROJECT_DIR"
    echo "   กรุณาตรวจสอบ path ของโปรเจ็กต์"
    exit 1
fi

# ตรวจสอบ virtual environment
if [[ ! -d "llm_rag_env" ]]; then
    echo "❌ ไม่พบ virtual environment"
    echo "   กรุณารัน setup/linux/setup_python_env.sh ก่อน"
    exit 1
fi

# เปิดใช้งาน virtual environment
echo "🔄 เปิดใช้งาน virtual environment..."
source llm_rag_env/bin/activate

# ตรวจสอบ LLM model
MODEL_PATH="$HOME/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf"
if [[ ! -f "$MODEL_PATH" ]]; then
    echo "❌ ไม่พบ LLM model ที่: $MODEL_PATH"
    echo "   กรุณารัน setup/linux/download_models.sh ก่อน"
    exit 1
fi

# ตั้งค่า environment variables
export CUDA_VISIBLE_DEVICES=0
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# รัน Streamlit
echo "🌟 เปิด Streamlit application..."
echo "📱 เปิด browser แล้วไปที่: http://localhost:8501"
echo "🛑 กด Ctrl+C เพื่อหยุดการทำงาน"
echo ""

streamlit run rag_chatbot.py

echo ""
echo "🏁 ปิด LLM-RAG Chatbot แล้ว"
