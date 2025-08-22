@echo off
chcp 65001 >nul
REM สคริปต์สำหรับสร้าง FAISS index บน Windows (ใช้ rebuild scripts ที่อัปเดตแล้ว)
REM ใช้ chunk size 120 อักษรและ StableSimpleEmbeddings 128 มิติ

cd /d "%~dp0..\.."

call llm_rag_env\Scripts\activate.bat

echo.
echo 📦 ตรวจสอบและติดตั้ง Python libraries ที่จำเป็น...
pip install --upgrade pip
pip install langchain>=0.1.0 langchain-community>=0.0.10
pip install faiss-cpu>=1.7.4
pip install transformers>=4.35.0
pip install sentence-transformers>=2.2.2
pip install numpy>=1.24.3
pip install torch>=2.1.0
echo ✅ Libraries ติดตั้งเรียบร้อยแล้ว!

echo.
echo 🎯 เลือก Vector Store ที่ต้องการสร้าง:
echo 1) Snake Vector Store
echo 2) Naruto Vector Store
echo 3) Naruto + Snake Vector Store
echo 4) สร้างทั้งหมด (All)
echo.
set /p choice="เลือกตัวเลือก (1-4): "

if "%choice%"=="1" (
    echo 🐍 สร้าง Snake Vector Store...
    python scripts\utilities\rebuild_snake_vector_final.py
) else if "%choice%"=="2" (
    echo 🥷 สร้าง Naruto Vector Store...
    python scripts\utilities\rebuild_naruto_vector_final.py
) else if "%choice%"=="3" (
    echo 🌟 สร้าง Naruto + Snake Vector Store...
    python scripts\utilities\rebuild_naruto_snake_vector_final.py
) else if "%choice%"=="4" (
    echo 🚀 สร้างทั้งหมด...
    echo 🐍 กำลังสร้าง Snake Vector Store...
    python scripts\utilities\rebuild_snake_vector_final.py
    echo.
    echo 🥷 กำลังสร้าง Naruto Vector Store...
    python scripts\utilities\rebuild_naruto_vector_final.py
    echo.
    echo 🌟 กำลังสร้าง Naruto + Snake Vector Store...
    python scripts\utilities\rebuild_naruto_snake_vector_final.py
) else (
    echo ❌ ตัวเลือกไม่ถูกต้อง กรุณาเลือก 1-4
    pause
    exit /b 1
)

echo.
echo ✅ เสร็จสิ้น!
pause
