@echo off
chcp 65001 >nul
REM CPU-only setup script for llama-cpp-python
REM สคริปต์ติดตั้งแบบ CPU-only สำหรับ llama-cpp-python

echo 💻 Setup llama-cpp-python แบบ CPU-only สำหรับ Windows
echo =========================================================

REM ตรวจสอบว่าอยู่ใน project directory
cd /d "%~dp0.."
if not exist "rag_chatbot.py" (
    echo ❌ ไม่พบไฟล์ rag_chatbot.py
    echo    กรุณา cd เข้าไปใน LLM-RAG directory ก่อน
    pause
    exit /b 1
)

echo 🔍 ตรวจสอบ Prerequisites...

REM ตรวจสอบ Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ไม่พบ Python
    echo    กรุณาติดตั้ง Python 3.8+ จาก https://python.org
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%v in ('python --version 2^>^&1') do echo ✅ Python %%v
)

REM ตรวจสอบ Virtual Environment
if not exist "llm_rag_env" (
    echo 📦 สร้าง Python virtual environment...
    python -m venv llm_rag_env
    if errorlevel 1 (
        echo ❌ ไม่สามารถสร้าง virtual environment ได้
        pause
        exit /b 1
    )
) else (
    echo ✅ พบ virtual environment แล้ว
)

echo 🔄 เปิดใช้งาน virtual environment...
call llm_rag_env\Scripts\activate.bat

REM อัพเกรด pip
echo 📦 อัพเกรด pip...
python -m pip install --upgrade pip

REM ตรวจสอบการติดตั้งปัจจุบัน
echo 🔍 ตรวจสอบการติดตั้ง llama-cpp-python ปัจจุบัน...
python -c "import llama_cpp; print('✅ พบ llama-cpp-python version:', llama_cpp.__version__)" 2>nul
if not errorlevel 1 (
    echo.
    echo 🤔 พบ llama-cpp-python ติดตั้งแล้ว
    set /p reinstall="ต้องการติดตั้งใหม่แบบ CPU-only หรือไม่? (y/n): "
    if /i not "%reinstall%"=="y" (
        echo ⏭️ ข้ามการติดตั้ง llama-cpp-python
        goto :install_other_packages
    )
    
    echo 🗑️ ลบ version เก่า...
    pip uninstall llama-cpp-python -y
)

echo 💻 ติดตั้ง llama-cpp-python แบบ CPU-only...
echo.
echo ⚠️ หมายเหตุ: 
echo    - ไม่ต้องการ Visual Studio Build Tools
echo    - ความเร็วจะน้อยกว่าแบบ GPU แต่เสถียรกว่า
echo    - เหมาะสำหรับการทดสอบและพัฒนา
echo.

REM ลองวิธีต่างๆ ตามลำดับ
echo 🔄 วิธีที่ 1: ติดตั้งจาก PyPI standard...
pip install llama-cpp-python==0.2.90 --no-cache-dir

if errorlevel 1 (
    echo ❌ วิธีที่ 1 ไม่สำเร็จ
    echo.
    echo 🔄 วิธีที่ 2: ติดตั้งจาก pre-compiled wheel...
    pip install --pre llama-cpp-python --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cpu
    
    if errorlevel 1 (
        echo ❌ วิธีที่ 2 ไม่สำเร็จ
        echo.
        echo 🔄 วิธีที่ 3: ติดตั้งแบบ basic...
        pip install llama-cpp-python --no-deps --no-cache-dir
        
        if errorlevel 1 (
            echo ❌ ทุกวิธีไม่สำเร็จ
            goto :installation_failed
        )
    )
)

echo ✅ ติดตั้ง llama-cpp-python เสร็จสิ้น!

REM ทดสอบการติดตั้ง
echo 🧪 ทดสอบ llama-cpp-python...
python -c "from llama_cpp import Llama; print('✅ llama-cpp-python ติดตั้งสำเร็จ')" 2>nul
if errorlevel 1 (
    echo ❌ ทดสอบไม่ผ่าน มีปัญหาในการติดตั้ง
    echo 💡 ลองรันคำสั่งนี้เพื่อดู error:
    echo    python -c "from llama_cpp import Llama"
    goto :installation_failed
) else (
    echo ✅ llama-cpp-python พร้อมใช้งาน!
)

:install_other_packages
REM ติดตั้ง packages อื่นๆ
echo 📦 ติดตั้ง packages อื่นๆ...
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers

echo.
echo 🎉 ติดตั้งแบบ CPU-only เสร็จสิ้น!
echo ==================================
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. รัน application: streamlit run rag_chatbot.py
echo 2. เปิด browser ไปที่: http://localhost:8501
echo 3. กด "Create chatbot" เพื่อโหลดโมเดล
echo 4. ตรวจสอบ performance:
echo    - CPU mode: ความเร็ว ~2000-2500 tokens/sec
echo    - Memory usage: ประมาณ 4-8 GB RAM
echo.
echo 💡 หมายเหตุ: หากต้องการเปลี่ยนเป็น GPU ในภายหลัง
echo    ให้รัน .\issue\setup_complete_gpu.bat แทน
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
echo 1️⃣ ตรวจสอบ Python และ pip:
echo    python --version
echo    pip --version
echo.
echo 2️⃣ อัพเกรด pip และ setuptools:
echo    python -m pip install --upgrade pip setuptools wheel
echo.
echo 3️⃣ ลองติดตั้งแบบ minimal:
echo    pip install llama-cpp-python --no-deps
echo.
echo 4️⃣ รันสคริปต์วินิจฉัย:
echo    .\issue\diagnose_llama_cpp.bat
echo.
echo 5️⃣ ดู troubleshooting guide:
echo    .\issue\LLAMA_CPP_PYTHON_TROUBLESHOOTING.md
echo.

pause
exit /b 1
