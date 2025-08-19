@echo off
chcp 65001 >nul
REM Performance Test for llama-cpp-python installation
REM ทดสอบประสิทธิภาพหลังการติดตั้ง llama-cpp-python

echo 🚀 ทดสอบประสิทธิภาพ llama-cpp-python
echo =====================================

REM ตรวจสอบว่าอยู่ใน project directory
if not exist "rag_chatbot.py" (
    echo ❌ ไม่พบไฟล์ rag_chatbot.py
    echo    กรุณา cd เข้าไปใน LLM-RAG directory ก่อน
    pause
    exit /b 1
)

REM เปิดใช้งาน virtual environment
if exist "llm_rag_env\Scripts\activate.bat" (
    echo 🔄 เปิดใช้งาน virtual environment...
    call llm_rag_env\Scripts\activate.bat
) else (
    echo ⚠️ ไม่พบ virtual environment
)

echo 🧪 ทดสอบการ import llama-cpp-python...
python -c "from llama_cpp import Llama; print('✅ Import สำเร็จ')" 2>nul
if errorlevel 1 (
    echo ❌ ไม่สามารถ import llama-cpp-python ได้
    echo 💡 กรุณาติดตั้ง llama-cpp-python ก่อน
    pause
    exit /b 1
)

echo 🔍 ตรวจสอบ version และ features...
python -c "
import llama_cpp
print(f'✅ llama-cpp-python version: {llama_cpp.__version__}')

# ตรวจสอบ CUDA support
try:
    import llama_cpp.llama_cpp as llama_cpp_lib
    if hasattr(llama_cpp_lib, 'GGML_USE_CUBLAS'):
        print('🚀 CUDA support: Available')
    else:
        print('💻 CUDA support: Not available (CPU-only)')
except:
    print('💻 Mode: CPU-only')

# ตรวจสอบ GPU
import subprocess
try:
    result = subprocess.run(['nvidia-smi', '--query-gpu=name,memory.total', '--format=csv,noheader,nounits'], 
                          capture_output=True, text=True, timeout=5)
    if result.returncode == 0:
        lines = result.stdout.strip().split('\n')
        for i, line in enumerate(lines):
            name, memory = line.split(', ')
            print(f'🎮 GPU {i}: {name} ({memory} MB)')
    else:
        print('💻 GPU: Not detected')
except:
    print('💻 GPU: Not available')
"

echo.
echo 📊 ทดสอบ performance พื้นฐาน...
echo    (ทดสอบการโหลดโมเดลขนาดเล็ก - จำลอง)
echo.

python -c "
import time
from llama_cpp import Llama

print('🔄 เริ่มทดสอบ performance...')
start_time = time.time()

try:
    # จำลองการโหลดโมเดล (ไม่ได้โหลดจริง)
    print('📁 ตรวจสอบ LLM model path...')
    
    import os
    model_path = r'C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf'
    
    if os.path.exists(model_path):
        print(f'✅ พบ model file: {os.path.basename(model_path)}')
        file_size = os.path.getsize(model_path) / (1024**3)  # GB
        print(f'📏 ขนาดไฟล์: {file_size:.2f} GB')
        
        # ทดสอบโหลดโมเดลจริง (ใช้ memory น้อย)
        print('🔄 ทดสอบโหลดโมเดล...')
        try:
            # ใช้ context_length เล็กเพื่อประหยัด memory
            llm = Llama(
                model_path=model_path,
                n_ctx=512,  # context length เล็ก
                n_threads=4,  # จำกัด threads
                verbose=False
            )
            
            load_time = time.time() - start_time
            print(f'✅ โหลดโมเดลสำเร็จ ใช้เวลา: {load_time:.2f} วินาที')
            
            # ทดสอบ generation
            print('🤖 ทดสอบ text generation...')
            gen_start = time.time()
            
            output = llm('Hello', max_tokens=5, echo=False)
            
            gen_time = time.time() - gen_start
            tokens_per_sec = 5 / gen_time if gen_time > 0 else 0
            
            print(f'📝 Generation ทดสอบ: {output[\"choices\"][0][\"text\"].strip()}')
            print(f'⚡ ความเร็ว: {tokens_per_sec:.1f} tokens/sec (ทดสอบเล็ก)')
            
        except Exception as e:
            print(f'⚠️ ไม่สามารถโหลดโมเดลได้: {str(e)}')
            print('💡 อาจเป็นเพราะ memory ไม่เพียงพอหรือ model file เสียหาย')
    else:
        print(f'❌ ไม่พบ model file: {model_path}')
        print('💡 กรุณาดาวน์โหลด model file ก่อน')
        
except Exception as e:
    print(f'❌ Error ในการทดสอบ: {str(e)}')

total_time = time.time() - start_time
print(f'⏱️ เวลาทดสอบทั้งหมด: {total_time:.2f} วินาที')
"

echo.
echo 📋 สรุปผลการทดสอบ:
echo =====================
echo.
echo 💾 Memory Usage:
python -c "
import psutil
import os

process = psutil.Process(os.getpid())
memory_info = process.memory_info()
memory_mb = memory_info.rss / 1024 / 1024

print(f'   - Current process: {memory_mb:.1f} MB')

# System memory
mem = psutil.virtual_memory()
print(f'   - System total: {mem.total / 1024**3:.1f} GB')
print(f'   - System available: {mem.available / 1024**3:.1f} GB')
print(f'   - System usage: {mem.percent:.1f}%')
"

echo.
echo 🎯 คำแนะนำ:
echo.
echo ✅ หากการทดสอบผ่านทั้งหมด:
echo    - พร้อมใช้งาน LLM-RAG application
echo    - รัน: streamlit run rag_chatbot.py
echo.
echo ⚠️ หากมีปัญหา:
echo    - ตรวจสอบ memory usage
echo    - ลดขนาด context length
echo    - ใช้โมเดลขนาดเล็กกว่า
echo.
echo 🚀 หากต้องการ performance ดีกว่า:
echo    - ติดตั้งแบบ GPU support
echo    - เพิ่ม RAM หรือ VRAM
echo    - ใช้ SSD สำหรับ model files
echo.

pause
