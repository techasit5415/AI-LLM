#!/bin/bash

# เปิดใช้งาน virtual environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_DIR"

# ตรวจสอบและเปิดใช้งาน virtual environment
if [ -f "llm_rag_env/bin/activate" ]; then
    source llm_rag_env/bin/activate
    echo "✅ Virtual environment activated"
elif [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
    echo "✅ Virtual environment activated"
else
    echo "⚠️ Virtual environment not found - continuing with system Python"
fi

echo
echo "🧪 เลือก test script ที่ต้องการรัน:"
echo "1) benchmark_llama_cpp.py - ทดสอบประสิทธิภาพ LLaMA model"
echo "2) check_llama_cuda.py - ตรวจสอบ CUDA support"
echo "3) test_gpu.py - ทดสอบ GPU detection"
echo "4) validate_gpu_setup.py - ตรวจสอบการติดตั้งแบบเต็ม"
echo "5) รันทุก script"
echo
read -p "เลือก (1-5): " choice

case $choice in
    1)
        script="scripts/testing/benchmark_llama_cpp.py"
        echo "📊 รัน benchmark test..."
        ;;
    2)
        script="scripts/testing/check_llama_cuda.py"
        echo "🔧 ตรวจสอบ CUDA support..."
        ;;
    3)
        script="scripts/testing/test_gpu.py"
        echo "🎮 ทดสอบ GPU detection..."
        ;;
    4)
        script="scripts/testing/validate_gpu_setup.py"
        echo "✅ รัน validation test แบบเต็ม..."
        ;;
    5)
        echo "🚀 รันทุก test script..."
        echo
        echo "📊 1/4: benchmark_llama_cpp.py"
        python3 scripts/testing/benchmark_llama_cpp.py
        echo
        echo "🔧 2/4: check_llama_cuda.py"
        python3 scripts/testing/check_llama_cuda.py
        echo
        echo "🎮 3/4: test_gpu.py"
        python3 scripts/testing/test_gpu.py
        echo
        echo "✅ 4/4: validate_gpu_setup.py"
        python3 scripts/testing/validate_gpu_setup.py
        echo
        echo "🎉 ทุก test เสร็จสิ้น!"
        read -p "กด Enter เพื่อออก..."
        exit 0
        ;;
    *)
        echo "❌ ตัวเลือกไม่ถูกต้อง กรุณาเลือก 1-5"
        exit 1
        ;;
esac

echo
echo "🔎 กำลังรัน: $script"
echo "================================"
python3 "$script"
echo "================================"
echo "✅ เสร็จสิ้น!"
echo
read -p "กด Enter เพื่อออก..."
