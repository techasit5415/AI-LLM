@echo off
chcp 65001 >nul
REM Model Download Script for Windows
REM ดาวน์โหลด LLM models และ embedding models บน Windows

echo 📥 กำลังดาวน์โหลด models สำหรับ LLM-RAG บน Windows...

REM สร้าง directories
echo 📁 สร้าง model directories...
if not exist "%USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF" (
    mkdir "%USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF"
)
if not exist "%USERPROFILE%\Documents\AI\embedding-models" (
    mkdir "%USERPROFILE%\Documents\AI\embedding-models"
)

REM ดาวน์โหลด LLM model
echo 🦙 ดาวน์โหลด Llama 3.2 3B Instruct GGUF...
cd /d "%USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF"

if not exist "Llama-3.2-3B-Instruct-Q5_K_M.gguf" (
    echo ⬇️ กำลังดาวน์โหลด... (ขนาด ~2.16 GB)
    echo ใช้เวลาประมาณ 5-15 นาที ขึ้นอยู่กับความเร็วอินเทอร์เน็ต
    
    REM ลองใช้ curl ก่อน
    curl --version >nul 2>&1
    if not errorlevel 1 (
        curl -L -o Llama-3.2-3B-Instruct-Q5_K_M.gguf https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf
    ) else (
        REM ถ้าไม่มี curl ให้ใช้ PowerShell
        powershell -Command "Invoke-WebRequest -Uri 'https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf' -OutFile 'Llama-3.2-3B-Instruct-Q5_K_M.gguf'"
    )
    
    if exist "Llama-3.2-3B-Instruct-Q5_K_M.gguf" (
        echo ✅ ดาวน์โหลด LLM model เสร็จแล้ว
    ) else (
        echo ❌ ดาวน์โหลด LLM model ไม่สำเร็จ
        echo กรุณาดาวน์โหลดด้วยตนเองจาก:
        echo https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf
    )
) else (
    echo ℹ️ LLM model มีอยู่แล้ว
)

REM ดาวน์โหลด embedding model (optional)
echo 🔤 ดาวน์โหลด embedding model...
cd /d "%USERPROFILE%\Documents\AI\embedding-models"

if not exist "all-MiniLM-L6-v2" (
    echo ⬇️ กำลังดาวน์โหลด sentence-transformers/all-MiniLM-L6-v2...
    git --version >nul 2>&1
    if not errorlevel 1 (
        git clone https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2
        echo ✅ ดาวน์โหลด embedding model เสร็จแล้ว
    ) else (
        echo ⚠️ ไม่พบ Git, ข้าม embedding model download
        echo   (ระบบจะใช้ online embedding แทน)
    )
) else (
    echo ℹ️ Embedding model มีอยู่แล้ว
)

REM แสดงข้อมูล models ที่ดาวน์โหลด
echo.
echo 📊 ข้อมูล models ที่ดาวน์โหลด:
echo LLM Model:
dir "%USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF"
echo.
echo Embedding Model:
dir "%USERPROFILE%\Documents\AI\embedding-models"

echo.
echo ✅ ดาวน์โหลด models เสร็จสิ้น!
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. แก้ไข path ใน rag_chatbot.py:
echo    LLM path: %USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf
echo    Embedding path: %USERPROFILE%\Documents\AI\embedding-models\all-MiniLM-L6-v2
echo.
echo 2. รัน application:
echo    run_app_windows.bat
pause
