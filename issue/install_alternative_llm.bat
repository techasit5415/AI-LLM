@echo off
chcp 65001 >nul
REM Alternative LLM Installation - ทางเลือกอื่นแทน llama-cpp-python
REM ใช้ Ollama หรือ Transformers แทน

echo 🔄 Alternative LLM Setup - ทางเลือกอื่นสำหรับ LLM
echo =================================================

REM ตรวจสอบว่าอยู่ใน project directory
cd /d "%~dp0.."
if not exist "rag_chatbot.py" (
    echo ❌ ไม่พบไฟล์ rag_chatbot.py
    echo    กรุณา cd เข้าไปใน LLM-RAG directory ก่อน
    pause
    exit /b 1
)

echo.
echo 🎯 เลือกทางเลือกสำหรับ LLM:
echo.
echo 1️⃣  Ollama (แนะนำ - ใช้งานง่าย)
echo     - ไม่ต้องการ compilation
echo     - รองรับ GPU และ CPU
echo     - จัดการโมเดลอัตโนมัติ
echo.
echo 2️⃣  Transformers + PyTorch (เสถียร)
echo     - ไลบรารี่มาตรฐานจาก Hugging Face
echo     - รองรับโมเดลหลากหลาย
echo     - เสถียรและใช้งานง่าย
echo.
echo 3️⃣  ยกเลิก
echo.

set /p choice="เลือกทางเลือก (1-3): "

if "%choice%"=="1" (
    goto :install_ollama
) else if "%choice%"=="2" (
    goto :install_transformers
) else if "%choice%"=="3" (
    echo 👋 ยกเลิกการติดตั้ง
    exit /b 0
) else (
    echo ❌ ตัวเลือกไม่ถูกต้อง
    pause
    exit /b 1
)

:install_ollama
echo.
echo 🦙 ติดตั้ง Ollama
echo ================

REM เปิดใช้งาน virtual environment
if exist "llm_rag_env\Scripts\activate.bat" (
    echo 🔄 เปิดใช้งาน virtual environment...
    call llm_rag_env\Scripts\activate.bat
) else (
    echo 📦 สร้าง virtual environment...
    python -m venv llm_rag_env
    call llm_rag_env\Scripts\activate.bat
)

echo 📦 อัพเกรด pip...
python -m pip install --upgrade pip

echo 🔽 ติดตั้ง Ollama Windows client...
echo    กำลังดาวน์โหลด Ollama...

REM ใช้ winget ติดตั้ง Ollama
winget install Ollama.Ollama --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo ⚠️ winget ไม่สำเร็จ ลองวิธีอื่น...
    echo.
    echo 💡 กรุณาติดตั้ง Ollama manual:
    echo    1. ไปที่: https://ollama.ai/download/windows
    echo    2. ดาวน์โหลดและติดตั้ง Ollama for Windows
    echo    3. รีสตาร์ท command prompt
    echo    4. รันสคริปต์นี้อีกครั้ง
    pause
    exit /b 1
)

echo 📦 ติดตั้ง Python package สำหรับ Ollama...
pip install ollama requests

echo 🧪 ทดสอบ Ollama...
python -c "
try:
    import ollama
    print('✅ Ollama Python client ติดตั้งสำเร็จ')
    
    # ทดสอบเชื่อมต่อ Ollama server
    try:
        response = ollama.list()
        print('✅ เชื่อมต่อ Ollama server สำเร็จ')
        print('📋 โมเดลที่มี:', len(response.get('models', [])), 'โมเดล')
    except Exception as e:
        print('⚠️ ไม่สามารถเชื่อมต่อ Ollama server:', str(e))
        print('💡 กรุณาเริ่ม Ollama service หรือรีสตาร์ทเครื่อง')
        
except ImportError:
    print('❌ ติดตั้ง Ollama Python client ไม่สำเร็จ')
    exit(1)
"

if errorlevel 1 (
    goto :installation_failed
)

echo.
echo 📦 ติดตั้ง dependencies อื่นๆ...
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers

echo.
echo 🎉 ติดตั้ง Ollama สำเร็จ!
echo =======================
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. ดาวน์โหลดโมเดล: ollama pull llama3.2:3b
echo 2. แก้ไข rag_chatbot.py ให้ใช้ Ollama แทน llama-cpp-python
echo 3. รัน: streamlit run rag_chatbot.py
echo.
echo 💡 โมเดลแนะนำ:
echo    ollama pull llama3.2:3b      (3GB)
echo    ollama pull llama3.1:8b      (4.7GB)
echo    ollama pull codellama:7b     (3.8GB)
echo.

goto :create_ollama_config

:install_transformers
echo.
echo 🤗 ติดตั้ง Transformers + PyTorch
echo ================================

REM เปิดใช้งาน virtual environment
if exist "llm_rag_env\Scripts\activate.bat" (
    echo 🔄 เปิดใช้งาน virtual environment...
    call llm_rag_env\Scripts\activate.bat
) else (
    echo 📦 สร้าง virtual environment...
    python -m venv llm_rag_env
    call llm_rag_env\Scripts\activate.bat
)

echo 📦 อัพเกรด pip...
python -m pip install --upgrade pip

echo 🔽 ติดตั้ง PyTorch (CPU version)...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

echo 🤗 ติดตั้ง Transformers และ dependencies...
pip install transformers accelerate

echo 🧪 ทดสอบ Transformers...
python -c "
try:
    import torch
    import transformers
    print('✅ PyTorch version:', torch.__version__)
    print('✅ Transformers version:', transformers.__version__)
    
    # ทดสอบโหลดโมเดลเล็ก
    from transformers import pipeline
    print('🔄 ทดสอบโหลด text generation pipeline...')
    # ใช้โมเดลเล็กสำหรับทดสอบ
    generator = pipeline('text-generation', model='distilgpt2', max_length=10)
    result = generator('Hello', max_length=10, num_return_sequences=1)
    print('✅ Text generation ทำงานได้!')
    
except Exception as e:
    print('❌ ทดสอบไม่สำเร็จ:', str(e))
    exit(1)
"

if errorlevel 1 (
    goto :installation_failed
)

echo.
echo 📦 ติดตั้ง dependencies อื่นๆ...
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers

echo.
echo 🎉 ติดตั้ง Transformers สำเร็จ!
echo ==============================
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. แก้ไข rag_chatbot.py ให้ใช้ Transformers
echo 2. เลือกโมเดลจาก Hugging Face Hub
echo 3. รัน: streamlit run rag_chatbot.py
echo.
echo 💡 โมเดลแนะนำ:
echo    microsoft/DialoGPT-medium
echo    microsoft/DialoGPT-large
echo    gpt2
echo.

goto :create_transformers_config

:create_ollama_config
echo.
echo 📝 สร้างไฟล์ config สำหรับ Ollama...

echo # Ollama Configuration > ollama_config.py
echo model_name = "llama3.2:3b" >> ollama_config.py
echo base_url = "http://localhost:11434" >> ollama_config.py

echo ✅ สร้าง ollama_config.py แล้ว
goto :finish

:create_transformers_config
echo.
echo 📝 สร้างไฟล์ config สำหรับ Transformers...

echo # Transformers Configuration > transformers_config.py
echo model_name = "microsoft/DialoGPT-medium" >> transformers_config.py
echo device = "cpu" >> transformers_config.py

echo ✅ สร้าง transformers_config.py แล้ว
goto :finish

:finish
echo.
echo 🔧 ขั้นตอนการแก้ไขโค้ด:
echo.
echo 1. แก้ไข rag_chatbot.py
echo 2. เปลี่ยนจาก llama_cpp import
echo 3. ใช้ Ollama หรือ Transformers แทน
echo.
echo 📖 ดูตัวอย่างการแก้ไขใน:
echo    .\issue\LLAMA_CPP_PYTHON_TROUBLESHOOTING.md
echo.

pause
exit /b 0

:installation_failed
echo.
echo ❌ การติดตั้งไม่สำเร็จ
echo ==================
echo.
echo 🔧 แนวทางแก้ไข:
echo.
echo 1️⃣ ตรวจสอบการเชื่อมต่อเครือข่าย
echo 2️⃣ ลองรันสคริปต์อีกครั้ง
echo 3️⃣ ติดตั้ง manual จากเว็บไซต์
echo 4️⃣ ใช้ทางเลือกอื่น (cloud services)
echo.

pause
exit /b 1
