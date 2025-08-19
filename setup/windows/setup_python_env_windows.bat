@echo off
chcp 65001 >nul
REM Python Environment Setup Script for Windows
REM รันหลังจากติดตั้ง system dependencies แล้ว

echo 🐍 กำลังตั้งค่า Python environment สำหรับ LLM-RAG บน Windows...

REM ตรวจสอบว่าอยู่ใน project directory
if not exist "requirements.txt" (
    echo ❌ ไม่พบไฟล์ requirements.txt
    echo    กรุณา cd เข้าไปใน LLM-RAG directory ก่อน
    pause
    exit /b 1
)

REM สร้าง virtual environment
echo 📦 สร้าง virtual environment...
if not exist "llm_rag_env" (
    python -m venv llm_rag_env
    echo ✅ สร้าง virtual environment เสร็จแล้ว
) else (
    echo ℹ️ virtual environment มีอยู่แล้ว
)

REM เปิดใช้งาน virtual environment
echo 🔄 เปิดใช้งาน virtual environment...
call llm_rag_env\Scripts\activate.bat

REM อัพเกรด pip
echo ⬆️ อัพเกรด pip...
python -m pip install --upgrade pip

REM ติดตั้ง basic packages ก่อน
echo 📦 ติดตั้ง basic packages...
pip install wheel setuptools

REM ติดตั้ง PyTorch ก่อน (เพื่อหลีกเลี่ยง conflict)
echo 🔥 ติดตั้ง PyTorch สำหรับ CUDA...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

REM ติดตั้ง packages อื่นๆ
echo 📦 ติดตั้ง packages จาก requirements.txt...
pip install streamlit==1.29.0
pip install langchain==0.1.0 langchain-community==0.0.10
pip install faiss-cpu==1.7.4
pip install sentence-transformers==2.2.2
pip install pypdf==3.17.4 python-docx==1.1.0
pip install tiktoken==0.5.2
pip install numpy==1.24.3 pandas==2.0.3
pip install requests==2.31.0 beautifulsoup4==4.12.2 lxml==4.9.3
pip install Pillow==10.1.0 python-dotenv==1.0.0

REM ติดตั้ง llama-cpp-python พร้อม CUDA support
echo 🦙 ติดตั้ง llama-cpp-python พร้อม CUDA support...
pip uninstall -y llama-cpp-python 2>nul
set CMAKE_ARGS=-DLLAMA_CUBLAS=on
pip install llama-cpp-python==0.2.90 --no-cache-dir

echo ✅ Python environment setup เสร็จสิ้น!
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. ดาวน์โหลด LLM model:
echo    download_models_windows.bat
echo.
echo 2. แก้ไข path ในไฟล์ rag_chatbot.py:
echo    Line 46: llm_model = r"C:\Users\%USERNAME%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf"
echo    Line 20: local_embed_path = r"C:\Users\%USERNAME%\Documents\AI\embedding-models\all-MiniLM-L6-v2"
echo.
echo 3. รัน application:
echo    run_app_windows.bat
echo.
echo 🎉 พร้อมใช้งาน!
pause
