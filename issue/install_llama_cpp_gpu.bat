@echo off
chcp 65001 >nul
REM Install llama-cpp-python with CUDA support after VS Build Tools installation
REM ติดตั้ง llama-cpp-python พร้อม GPU support หลังจากติดตั้ง VS Build Tools แล้ว

echo 🔧 ติดตั้ง llama-cpp-python พร้อม CUDA support...

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

echo 📦 ตรวจสอบ Visual Studio Build Tools...
where cl >nul 2>&1
if errorlevel 1 (
    echo 🔍 ไม่พบ Visual Studio Build Tools ใน PATH
    echo    กำลังเพิ่ม VS Build Tools ใน PATH...
    
    REM เพิ่ม VS Build Tools ใน PATH
    call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" 2>nul
    if errorlevel 1 (
        echo ❌ ไม่พบ Visual Studio Build Tools
        echo    กรุณาติดตั้ง Visual Studio Build Tools 2022 ก่อน
        echo    https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
        pause
        exit /b 1
    )
) else (
    echo ✅ พบ Visual Studio Build Tools แล้ว
)

echo 🔥 ติดตั้ง llama-cpp-python พร้อม CUDA support...

REM ลบ version เก่าก่อน (ถ้ามี)
pip uninstall llama-cpp-python -y

REM ตั้งค่า environment variables สำหรับ CUDA
set CMAKE_ARGS=-DLLAMA_CUBLAS=on
set FORCE_CMAKE=1

echo 📋 CMAKE_ARGS: %CMAKE_ARGS%
echo 📋 FORCE_CMAKE: %FORCE_CMAKE%

REM ติดตั้ง llama-cpp-python
echo ⬇️ กำลังติดตั้ง... (อาจใช้เวลา 5-10 นาที)
pip install llama-cpp-python==0.2.90 --no-cache-dir --force-reinstall --verbose

if errorlevel 1 (
    echo ❌ ติดตั้งไม่สำเร็จ!
    echo 💡 ลองวิธีอื่น: ติดตั้งแบบ CPU-only ก่อน
    echo.
    set /p choice="ต้องการติดตั้งแบบ CPU-only หรือไม่? (y/n): "
    if /i "%choice%"=="y" (
        echo 🔄 กำลังติดตั้งแบบ CPU-only...
        pip install llama-cpp-python==0.2.90 --no-cache-dir
        if not errorlevel 1 (
            echo ✅ ติดตั้งแบบ CPU-only สำเร็จ
            echo ⚠️ จะใช้ CPU ในการประมวลผล (ช้ากว่า GPU)
        )
    )
) else (
    echo ✅ ติดตั้ง llama-cpp-python สำเร็จ!
    
    REM ทดสอบการใช้งาน CUDA
    echo 🧪 ทดสอบ CUDA support...
    python -c "from llama_cpp import Llama; print('✅ llama-cpp-python ติดตั้งสำเร็จ')"
    
    if not errorlevel 1 (
        echo ✅ llama-cpp-python พร้อมใช้งาน!
        echo 🚀 ตอนนี้สามารถรัน application ได้แล้ว
    )
)

echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. รัน application: streamlit run rag_chatbot.py
echo 2. ตรวจสอบ log ว่ามีการใช้ GPU หรือไม่
echo    - หา "assigned to device CUDA0" ใน log
echo    - ความเร็ว > 3000 tokens/sec = GPU working
echo    - ความเร็ว ~2500 tokens/sec = CPU only
echo.

pause
