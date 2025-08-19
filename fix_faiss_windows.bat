@echo off
chcp 65001 >nul
REM Fix FAISS Compatibility Issue for Windows
REM แก้ไขปัญหา FAISS allow_dangerous_deserialization

echo 🔧 แก้ไขปัญหา FAISS Compatibility...

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

echo 🔄 เปิดใช้งาน virtual environment...
call llm_rag_env\Scripts\activate.bat

echo 📦 อัพเดต packages ที่เกี่ยวข้อง...

REM อัพเดต langchain packages
pip install --upgrade langchain==0.1.20
pip install --upgrade langchain-community==0.0.38

REM ตรวจสอบและลองอัพเดต faiss-cpu หากจำเป็น
pip install --upgrade faiss-cpu==1.7.4

echo 🧪 ทดสอบ FAISS compatibility...
python fix_faiss_compatibility.py

echo.
echo ✅ เสร็จสิ้นการแก้ไขปัญหา FAISS compatibility!
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. ลองรัน application อีกครั้ง: streamlit run rag_chatbot.py
echo 2. หากยังมีปัญหา ให้ลองรีสตาร์ท terminal แล้วรันใหม่
echo.

pause
