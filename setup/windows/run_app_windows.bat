@echo off
chcp 65001 >nul
REM Run LLM-RAG Application on Windows

echo 🚀 เริ่มต้น LLM-RAG Chatbot บน Windows...

REM ตรวจสอบว่าอยู่ใน project directory
if not exist "rag_chatbot.py" (
    echo ❌ ไม่พบไฟล์ rag_chatbot.py
    echo    กรุณา cd เข้าไปใน LLM-RAG directory ก่อน
    pause
    exit /b 1
)

REM ตรวจสอบ virtual environment
if not exist "llm_rag_env" (
    echo ❌ ไม่พบ virtual environment
    echo    กรุณารัน setup_python_env_windows.bat ก่อน
    pause
    exit /b 1
)

REM เปิดใช้งาน virtual environment
echo 🔄 เปิดใช้งาน virtual environment...
call llm_rag_env\Scripts\activate.bat

REM ตรวจสอบ LLM model
set MODEL_PATH=C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf
if not exist "%MODEL_PATH%" (
    echo ❌ ไม่พบ LLM model ที่: %MODEL_PATH%
    echo    กรุณารัน download_models_windows.bat ก่อน
    pause
    exit /b 1
)

REM ตั้งค่า environment variables
set CUDA_VISIBLE_DEVICES=0

REM รัน Streamlit
echo 🌟 เปิด Streamlit application...
echo 📱 เปิด browser แล้วไปที่: http://localhost:8501
echo 🛑 กด Ctrl+C เพื่อหยุดการทำงาน
echo.

streamlit run rag_chatbot_windows.py

echo.
echo 🏁 ปิด LLM-RAG Chatbot แล้ว
pause
