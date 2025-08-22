@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM เปิดใช้งาน virtual environment
cd /d "%~dp0..\.."
call llm_rag_env\Scripts\activate.bat

echo.
echo 🧪 เลือก test script ที่ต้องการรัน:
echo 1) benchmark_llama_cpp.py - ทดสอบประสิทธิภาพ LLaMA model
echo 2) check_llama_cuda.py - ตรวจสอบ CUDA support
echo 3) test_gpu.py - ทดสอบ GPU detection
echo 4) validate_gpu_setup.py - ตรวจสอบการติดตั้งแบบเต็ม
echo 5) รันทุก script
echo.
set /p choice="เลือก (1-5): "

if "%choice%"=="1" (
    set script=scripts\testing\benchmark_llama_cpp.py
    echo 📊 รัน benchmark test...
) else if "%choice%"=="2" (
    set script=scripts\testing\check_llama_cuda.py
    echo 🔧 ตรวจสอบ CUDA support...
) else if "%choice%"=="3" (
    set script=scripts\testing\test_gpu.py
    echo 🎮 ทดสอบ GPU detection...
) else if "%choice%"=="4" (
    set script=scripts\testing\validate_gpu_setup.py
    echo ✅ รัน validation test แบบเต็ม...
) else if "%choice%"=="5" (
    echo 🚀 รันทุก test script...
    echo.
    echo 📊 1/4: benchmark_llama_cpp.py
    python scripts\testing\benchmark_llama_cpp.py
    echo.
    echo 🔧 2/4: check_llama_cuda.py
    python scripts\testing\check_llama_cuda.py
    echo.
    echo 🎮 3/4: test_gpu.py
    python scripts\testing\test_gpu.py
    echo.
    echo ✅ 4/4: validate_gpu_setup.py
    python scripts\testing\validate_gpu_setup.py
    echo.
    echo 🎉 ทุก test เสร็จสิ้น!
    pause
    exit /b 0
) else (
    echo ❌ ตัวเลือกไม่ถูกต้อง กรุณาเลือก 1-5
    pause
    exit /b 1
)

echo.
echo 🔎 กำลังรัน: %script%
echo ================================
python "%script%"
echo ================================
echo ✅ เสร็จสิ้น!
echo.
pause
