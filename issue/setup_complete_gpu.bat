@echo off
chcp 65001 >nul
REM Complete setup script for llama-cpp-python with GPU support
REM สคริปต์ติดตั้งครบชุดสำหรับ llama-cpp-python พร้อม GPU support

echo 🚀 Setup llama-cpp-python พร้อม GPU support สำหรับ Windows
echo =================================================================

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

REM ตรวจสอบ Git
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ไม่พบ Git
    echo    กรุณาติดตั้ง Git จาก https://git-scm.com
    pause
    exit /b 1
) else (
    for /f "tokens=3" %%v in ('git --version 2^>^&1') do echo ✅ Git %%v
)

REM ตรวจสอบ NVIDIA GPU
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo ⚠️ ไม่พบ NVIDIA GPU หรือ driver
    echo    จะติดตั้งแบบ CPU-only
    set GPU_SUPPORT=false
) else (
    echo ✅ พบ NVIDIA GPU
    nvidia-smi | findstr "CUDA Version"
    set GPU_SUPPORT=true
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

REM ตรวจสอบ Visual Studio Build Tools
echo 🔍 ตรวจสอบ Visual Studio Build Tools...
where cl >nul 2>&1
if errorlevel 1 (
    echo ⚠️ ไม่พบ Visual Studio Build Tools
    
    REM ลองหา VS Build Tools ใน location มาตรฐาน
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
        echo 🔧 กำลังโหลด VS Build Tools environment...
        call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
    ) else (
        echo ❌ ไม่พบ Visual Studio Build Tools
        echo.
        echo 📋 กรุณาติดตั้ง Visual Studio Build Tools 2022:
        echo    1. รัน: winget install Microsoft.VisualStudio.2022.BuildTools
        echo    2. หรือดาวน์โหลดจาก: https://visualstudio.microsoft.com/downloads/
        echo    3. ในการติดตั้ง เลือก "C++ build tools" workload
        echo.
        set /p choice="ต้องการติดตั้ง Build Tools ตอนนี้หรือไม่? (y/n): "
        if /i "%choice%"=="y" (
            echo 🔽 กำลังติดตั้ง Visual Studio Build Tools...
            winget install Microsoft.VisualStudio.2022.BuildTools --accept-source-agreements --accept-package-agreements
            echo ⏰ รอการติดตั้งเสร็จแล้วรันสคริปต์นี้อีกครั้ง
            pause
            exit /b 0
        )
        
        echo 💡 จะติดตั้งแบบ CPU-only แทน
        set GPU_SUPPORT=false
    )
) else (
    echo ✅ พบ Visual Studio Build Tools แล้ว
)

REM ติดตั้ง dependencies พื้นฐาน
echo 📦 ติดตั้ง dependencies พื้นฐาน...
pip install wheel setuptools

REM ตรวจสอบว่ามี llama-cpp-python ติดตั้งแล้วหรือไม่
echo 🔍 ตรวจสอบการติดตั้ง llama-cpp-python ปัจจุบัน...
python -c "import llama_cpp; print('✅ พบ llama-cpp-python version:', llama_cpp.__version__)" 2>nul
if not errorlevel 1 (
    echo.
    echo � พบ llama-cpp-python ติดตั้งแล้ว
    set /p reinstall="ต้องการติดตั้งใหม่หรือไม่? (y/n): "
    if /i "%reinstall%"=="n" (
        echo ⏭️ ข้ามการติดตั้ง llama-cpp-python
        goto :install_other_packages
    )
)

echo �🦙 ติดตั้ง llama-cpp-python...

REM ลบ version เก่าก่อน
echo 🗑️ ลบ version เก่า...
pip uninstall llama-cpp-python -y >nul 2>&1

if "%GPU_SUPPORT%"=="true" (
    echo.
    echo 🚀 ติดตั้งพร้อม CUDA support...
    echo ⚠️ หมายเหตุ: การติดตั้งแบบ GPU อาจใช้เวลา 5-15 นาที และต้องการ Visual Studio Build Tools
    echo.
    
    set /p gpu_choice="ต้องการติดตั้งแบบ GPU หรือไม่? (y/n): "
    if /i "%gpu_choice%"=="y" (
        echo 🔍 ตรวจสอบ CUDA version...
        nvcc --version | findstr "release"
        
        echo ⬇️ กำลังติดตั้งแบบ GPU สำหรับ CUDA 12.1...
        pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cu121 --no-cache-dir --force-reinstall
        
        if errorlevel 1 (
            echo.
            echo ❌ ติดตั้งแบบ GPU ไม่สำเร็จ!
            echo.
            echo 💡 สาเหตุที่เป็นไปได้:
            echo    - ไม่มี Visual Studio Build Tools ครบถ้วน
            echo    - ไม่มี CUDA Toolkit
            echo    - Memory ไม่เพียงพอ
            echo.
            set /p fallback="ต้องการติดตั้งแบบ CPU แทนหรือไม่? (y/n): "
            if /i "%fallback%"=="y" (
                echo 💻 กำลังติดตั้งแบบ CPU...
                pip install llama-cpp-python --no-cache-dir
                if not errorlevel 1 (
                    echo ✅ ติดตั้งแบบ CPU สำเร็จ!
                ) else (
                    echo ❌ ติดตั้งแบบ CPU ก็ไม่สำเร็จ
                    goto :installation_failed
                )
            ) else (
                echo ❌ ยกเลิกการติดตั้ง
                goto :installation_failed
            )
        ) else (
            echo ✅ ติดตั้งแบบ GPU สำเร็จ!
        )
    ) else (
        echo 💻 ติดตั้งแบบ CPU ตามที่เลือก...
        pip install llama-cpp-python --no-cache-dir
        if not errorlevel 1 (
            echo ✅ ติดตั้งแบบ CPU สำเร็จ!
        ) else (
            goto :installation_failed
        )
    )
) else (
    echo 💻 ติดตั้งแบบ CPU-only...
    pip install llama-cpp-python --no-cache-dir
    if not errorlevel 1 (
        echo ✅ ติดตั้งแบบ CPU สำเร็จ!
    ) else (
        goto :installation_failed
    )
)

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
echo 🎉 ติดตั้งเสร็จสิ้น!
echo ===================
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. รัน application: streamlit run rag_chatbot.py
echo 2. เปิด browser ไปที่: http://localhost:8501
echo 3. กด "Create chatbot" เพื่อโหลดโมเดล
echo 4. ตรวจสอบ performance:
if "%GPU_SUPPORT%"=="true" (
    echo    - GPU mode: หา "assigned to device CUDA0" ใน log
    echo    - ความเร็ว: 3000+ tokens/sec
) else (
    echo    - CPU mode: ความเร็ว ~2500 tokens/sec
)
echo.
echo 💡 หมายเหตุ: หากต้องการเปลี่ยนจาก CPU เป็น GPU ในภายหลัง
echo    ให้รันสคริปต์นี้อีกครั้งและเลือกติดตั้งใหม่
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
echo 1️⃣ ตรวจสอบ Visual Studio Build Tools:
echo    winget install Microsoft.VisualStudio.2022.BuildTools
echo.
echo 2️⃣ ลองใช้ pre-compiled wheel สำหรับ CUDA 12.1:
echo    pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cu121 --no-cache-dir
echo.
echo 3️⃣ รันสคริปต์วินิจฉัย:
echo    .\issue\diagnose_llama_cpp.bat
echo.
echo 4️⃣ ติดตั้งแบบ CPU-only:
echo    pip install llama-cpp-python --no-cache-dir
echo.
echo 5️⃣ ดู troubleshooting guide:
echo    .\issue\LLAMA_CPP_PYTHON_TROUBLESHOOTING.md
echo.
echo 💡 เคล็ดลับ: รันสคริปต์นี้อีกครั้งหลังจากแก้ปัญหาแล้ว
echo    สคริปต์จะจำการตั้งค่าและให้เลือกการติดตั้งใหม่ได้
echo.

pause
exit /b 1
