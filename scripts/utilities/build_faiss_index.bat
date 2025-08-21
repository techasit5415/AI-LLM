@echo off
chcp 65001 >nul
REM สคริปต์สำหรับสร้าง FAISS index บน Windows (ใช้ rebuild scripts ที่อัปเดตแล้ว)
REM ใช้ chunk size 120 อักษรและ StableSimpleEmbeddings 128 มิติ

cd /d "%~dp0..\.."

call llm_rag_env\Scripts\activate.bat

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
