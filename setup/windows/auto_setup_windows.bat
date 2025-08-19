@echo off
chcp 65001 >nul
REM LLM-RAG Windows Auto Setup Script
REM สำหรับติดตั้งระบบ RAG Chatbot แบบ Local LLM บน Windows

echo 🚀 เริ่มติดตั้ง LLM-RAG Chatbot System บน Windows...

REM ตรวจสอบ Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ไม่พบ Python! กรุณาติดตั้ง Python จาก python.org
    echo    ✅ เลือก "Add Python to PATH" เวลาติดตั้ง
    pause
    exit /b 1
)
echo ✅ พบ Python แล้ว

REM ตรวจสอบ pip
pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ไม่พบ pip!
    pause
    exit /b 1
)
echo ✅ พบ pip แล้ว

REM ตรวจสอบ NVIDIA GPU
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo ⚠️ ไม่พบ NVIDIA GPU หรือ driver
    echo   กรุณาติดตั้ง NVIDIA driver และ CUDA Toolkit
    echo   https://developer.nvidia.com/cuda-downloads
) else (
    echo ✅ พบ NVIDIA GPU แล้ว
    nvidia-smi
)

REM ตรวจสอบ CUDA
nvcc --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️ ไม่พบ CUDA Toolkit
    echo   กรุณาติดตั้ง CUDA Toolkit จาก NVIDIA
) else (
    echo ✅ พบ CUDA Toolkit แล้ว
    nvcc --version
)

REM ตรวจสอบ Git
git --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️ ไม่พบ Git
    echo   กรุณาติดตั้ง Git for Windows จาก git-scm.com
) else (
    echo ✅ พบ Git แล้ว
)

REM สร้าง directory structure
echo 📁 สร้าง directory structure...
if not exist "%USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF" (
    mkdir "%USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF"
)
if not exist "%USERPROFILE%\Documents\AI\embedding-models" (
    mkdir "%USERPROFILE%\Documents\AI\embedding-models"
)

echo ✅ Windows system check เสร็จสิ้น!
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. รัน: setup_python_env_windows.bat
echo 2. รัน: download_models_windows.bat
echo 3. แก้ไข path ในไฟล์ rag_chatbot.py
echo 4. รัน: run_app_windows.bat
echo.
echo 📖 อ่านคู่มือเต็มใน WINDOWS_SETUP.md
pause
