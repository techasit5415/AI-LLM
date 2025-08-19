@echo off
chcp 65001 >nul
REM ========================================================================
REM  LLama-CPP-Python Installation Script for Windows
REM  สคริปต์ติดตั้ง llama-cpp-python สำหรับ Windows (ละเอียดครบถ้วน)
REM ========================================================================

title LLama-CPP-Python Installation Wizard

echo.
echo 🚀 LLama-CPP-Python Installation Wizard for Windows
echo ====================================================
echo.
echo 📋 สคริปต์นี้จะช่วยติดตั้ง llama-cpp-python พร้อม GPU support
echo    โดยตรวจสอบและติดตั้ง dependencies ที่จำเป็นทั้งหมด
echo.

REM ==================== ตรวจสอบ Prerequisites ====================

echo 🔍 [ขั้นตอนที่ 1/8] ตรวจสอบ Prerequisites...
echo -----------------------------------------------

REM ตรวจสอบว่าอยู่ใน project directory
if not exist "rag_chatbot.py" (
    echo ❌ ERROR: ไม่พบไฟล์ rag_chatbot.py
    echo    กรุณา cd เข้าไปใน LLM-RAG project directory ก่อน
    echo    ตัวอย่าง: cd "C:\path\to\LLM-RAG"
    echo.
    pause
    exit /b 1
)

echo ✅ อยู่ใน LLM-RAG project directory แล้ว

REM ตรวจสอบสิทธิ์ Administrator
net session >nul 2>&1
if errorlevel 1 (
    echo ⚠️ WARNING: ไม่ได้รันด้วยสิทธิ์ Administrator
    echo    บางขั้นตอนอาจต้องการสิทธิ์ Admin
    echo    แนะนำให้รันใหม่ด้วย "Run as Administrator"
    echo.
    set /p continue="ต้องการดำเนินการต่อหรือไม่? (y/n): "
    if /i not "%continue%"=="y" exit /b 0
) else (
    echo ✅ รันด้วยสิทธิ์ Administrator
)

REM ตรวจสอบ Python
echo 🐍 ตรวจสอบ Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: ไม่พบ Python
    echo    กรุณาติดตั้ง Python 3.8+ จาก https://python.org
    echo    ในการติดตั้ง ต้องเลือก "Add Python to PATH"
    echo.
    set /p install_python="ต้องการเปิด Python download page หรือไม่? (y/n): "
    if /i "%install_python%"=="y" start https://python.org/downloads/
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%v in ('python --version 2^>^&1') do (
        echo ✅ Python %%v
        set PYTHON_VERSION=%%v
    )
)

REM ตรวจสอบ pip
echo 📦 ตรวจสอบ pip...
pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: ไม่พบ pip
    echo    กรุณาติดตั้ง pip หรือใช้ python -m pip แทน
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%v in ('pip --version 2^>^&1') do echo ✅ pip %%v
)

REM ตรวจสอบ Git
echo 📁 ตรวจสอบ Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: ไม่พบ Git
    echo    กรุณาติดตั้ง Git for Windows จาก https://git-scm.com
    echo.
    set /p install_git="ต้องการเปิด Git download page หรือไม่? (y/n): "
    if /i "%install_git%"=="y" start https://git-scm.com/download/win
    pause
    exit /b 1
) else (
    for /f "tokens=3" %%v in ('git --version 2^>^&1') do echo ✅ Git %%v
)

REM ตรวจสอบ NVIDIA GPU
echo 🎮 ตรวจสอบ NVIDIA GPU...
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo ⚠️ WARNING: ไม่พบ NVIDIA GPU หรือ driver
    echo    จะติดตั้งแบบ CPU-only (ช้ากว่า GPU)
    set GPU_SUPPORT=false
    set GPU_INFO=CPU-only
) else (
    echo ✅ พบ NVIDIA GPU
    for /f "tokens=*" %%a in ('nvidia-smi --query-gpu^=name --format^=csv^,noheader^,nounits 2^>nul') do set GPU_NAME=%%a
    for /f "tokens=*" %%a in ('nvidia-smi --query-gpu^=driver_version --format^=csv^,noheader^,nounits 2^>nul') do set DRIVER_VERSION=%%a
    echo    GPU: !GPU_NAME!
    echo    Driver: !DRIVER_VERSION!
    set GPU_SUPPORT=true
    set GPU_INFO=!GPU_NAME!
)

echo.
echo 📊 สรุประบบ:
echo    - Python: %PYTHON_VERSION%
echo    - GPU: %GPU_INFO%
echo    - OS: Windows
echo.

REM ==================== ตรวจสอบ Virtual Environment ====================

echo 🔍 [ขั้นตอนที่ 2/8] ตรวจสอบ Python Virtual Environment...
echo -----------------------------------------------------------

if not exist "llm_rag_env" (
    echo 📦 สร้าง Python virtual environment...
    python -m venv llm_rag_env
    if errorlevel 1 (
        echo ❌ ERROR: ไม่สามารถสร้าง virtual environment ได้
        echo    ตรวจสอบ:
        echo    1. Python ติดตั้งถูกต้อง
        echo    2. มีพื้นที่ disk เพียงพอ
        echo    3. ไม่มี antivirus block
        pause
        exit /b 1
    )
    echo ✅ สร้าง virtual environment สำเร็จ
) else (
    echo ✅ พบ virtual environment แล้ว
)

echo 🔄 เปิดใช้งาน virtual environment...
call llm_rag_env\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ ERROR: ไม่สามารถเปิดใช้งาน virtual environment ได้
    pause
    exit /b 1
)

echo ✅ เปิดใช้งาน virtual environment สำเร็จ

REM ==================== อัพเกรด pip ====================

echo 🔍 [ขั้นตอนที่ 3/8] อัพเกรด pip และ setuptools...
echo ------------------------------------------------

echo 📦 อัพเกรด pip...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo ⚠️ WARNING: ไม่สามารถอัพเกรด pip ได้ แต่จะดำเนินการต่อ
) else (
    echo ✅ อัพเกรด pip สำเร็จ
)

echo 📦 ติดตั้ง build tools พื้นฐาน...
pip install wheel setuptools cmake
if errorlevel 1 (
    echo ⚠️ WARNING: ติดตั้ง build tools ไม่สมบูรณ์
) else (
    echo ✅ ติดตั้ง build tools สำเร็จ
)

REM ==================== ตรวจสอบ Visual Studio Build Tools ====================

echo 🔍 [ขั้นตอนที่ 4/8] ตรวจสอบ Visual Studio Build Tools...
echo --------------------------------------------------------

echo 🔧 ตรวจสอบ C++ compiler...
where cl >nul 2>&1
if errorlevel 1 (
    echo ⚠️ WARNING: ไม่พบ Visual Studio C++ compiler
    
    REM ลองหา VS installation ใน location มาตรฐาน
    set VS_FOUND=false
    if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" (
        set VS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat
        set VS_FOUND=true
        set VS_VERSION=Community 2022
    ) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" (
        set VS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat
        set VS_FOUND=true
        set VS_VERSION=Professional 2022
    ) else if exist "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
        set VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat
        set VS_FOUND=true
        set VS_VERSION=BuildTools 2022
    ) else if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat" (
        set VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat
        set VS_FOUND=true
        set VS_VERSION=BuildTools 2019
    )
    
    if "!VS_FOUND!"=="true" (
        echo 🔧 พบ Visual Studio !VS_VERSION!
        echo    กำลังโหลด build environment...
        call "!VS_PATH!" >nul 2>&1
        
        REM ตรวจสอบอีกครั้งหลัง load environment
        where cl >nul 2>&1
        if not errorlevel 1 (
            echo ✅ โหลด Visual Studio environment สำเร็จ
            set HAS_COMPILER=true
        ) else (
            echo ❌ โหลด Visual Studio environment ไม่สำเร็จ
            set HAS_COMPILER=false
        )
    ) else (
        echo ❌ ไม่พบ Visual Studio Build Tools
        set HAS_COMPILER=false
    )
    
    if "!HAS_COMPILER!"=="false" (
        echo.
        echo 💡 ต้องการติดตั้ง Visual Studio Build Tools เพื่อ compile C++ code
        echo    หากไม่ติดตั้ง จะใช้ pre-compiled wheel (อาจไม่มี GPU support)
        echo.
        echo 📋 ตัวเลือก:
        echo    1. ติดตั้ง Visual Studio Community (แนะนำ)
        echo    2. ติดตั้ง Visual Studio Build Tools
        echo    3. ข้ามและใช้ pre-compiled wheel
        echo.
        set /p vs_choice="เลือกตัวเลือก (1/2/3): "
        
        if "!vs_choice!"=="1" (
            echo 🔽 เปิด Visual Studio Community download page...
            start https://visualstudio.microsoft.com/vs/community/
            echo 📋 ในการติดตั้ง กรุณาเลือก:
            echo    - Desktop development with C++
            echo    - MSVC v143 - VS 2022 C++ x64/x86 build tools
            echo    - Windows 10/11 SDK
            echo.
            echo ⏰ หลังจากติดตั้งเสร็จ ให้รีสตาร์ทและรันสคริปต์นี้อีกครั้ง
            pause
            exit /b 0
        ) else if "!vs_choice!"=="2" (
            echo 🔽 กำลังติดตั้ง Visual Studio Build Tools...
            winget install Microsoft.VisualStudio.2022.BuildTools
            echo ⏰ หลังจากติดตั้งเสร็จ ให้รีสตาร์ทและรันสคริปต์นี้อีกครั้ง
            pause
            exit /b 0
        ) else (
            echo 💻 จะใช้ pre-compiled wheel แทน
            set USE_PRECOMPILED=true
        )
    )
) else (
    echo ✅ พบ Visual Studio C++ compiler แล้ว
    for /f "tokens=*" %%a in ('cl 2^>^&1 ^| findstr "Version"') do echo    %%a
    set HAS_COMPILER=true
    set USE_PRECOMPILED=false
)

REM ==================== ติดตั้ง PyTorch ====================

echo 🔍 [ขั้นตอนที่ 5/8] ติดตั้ง PyTorch...
echo --------------------------------------

echo 🔥 ตรวจสอบ PyTorch...
python -c "import torch; print('PyTorch version:', torch.__version__)" >nul 2>&1
if not errorlevel 1 (
    echo ✅ PyTorch ติดตั้งแล้ว
    for /f "tokens=*" %%a in ('python -c "import torch; print(torch.__version__)" 2^>nul') do echo    Version: %%a
) else (
    echo 📦 ติดตั้ง PyTorch...
    if "%GPU_SUPPORT%"=="true" (
        echo    กำลังติดตั้ง PyTorch พร้อม CUDA support...
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    ) else (
        echo    กำลังติดตั้ง PyTorch CPU-only...
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    )
    
    if errorlevel 1 (
        echo ❌ ERROR: ติดตั้ง PyTorch ไม่สำเร็จ
        echo    ลองติดตั้งแบบ default...
        pip install torch torchvision torchaudio
        if errorlevel 1 (
            echo ❌ ERROR: ติดตั้ง PyTorch ไม่สำเร็จ
            pause
            exit /b 1
        )
    )
    echo ✅ ติดตั้ง PyTorch สำเร็จ
)

REM ==================== ติดตั้ง llama-cpp-python ====================

echo 🔍 [ขั้นตอนที่ 6/8] ติดตั้ง llama-cpp-python...
echo -----------------------------------------------

echo 🦙 ลบ llama-cpp-python เก่า (ถ้ามี)...
pip uninstall llama-cpp-python -y >nul 2>&1

if "%USE_PRECOMPILED%"=="true" (
    echo 📦 ติดตั้งจาก pre-compiled wheel...
    
    if "%GPU_SUPPORT%"=="true" (
        echo    ลอง CUDA wheel ก่อน...
        pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cu121
        if errorlevel 1 (
            echo    CUDA wheel ไม่สำเร็จ ลอง CPU wheel...
            pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cpu
        )
    ) else (
        echo    ติดตั้ง CPU wheel...
        pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cpu
    )
) else (
    echo 🔨 Compile จาก source code...
    
    if "%GPU_SUPPORT%"=="true" (
        echo    ตั้งค่า environment สำหรับ CUDA...
        set CMAKE_ARGS=-DLLAMA_CUBLAS=on
        set FORCE_CMAKE=1
        echo    CMAKE_ARGS: %CMAKE_ARGS%
    ) else (
        echo    ตั้งค่า environment สำหรับ CPU...
        set CMAKE_ARGS=-DLLAMA_CUBLAS=off
    )
    
    echo    กำลัง compile... (อาจใช้เวลา 5-15 นาที)
    echo    โปรดรอและไม่ต้องตกใจถ้ามี warning
    echo.
    pip install llama-cpp-python==0.2.90 --no-cache-dir --force-reinstall --verbose
)

if errorlevel 1 (
    echo ❌ ERROR: ติดตั้ง llama-cpp-python ไม่สำเร็จ
    echo.
    echo 💡 ทางเลือก:
    echo    1. ลองติดตั้ง CPU-only version
    echo    2. ใช้ alternative LLM library (transformers)
    echo    3. ใช้ online API (OpenAI, Anthropic)
    echo.
    set /p fallback="ต้องการลอง CPU-only version หรือไม่? (y/n): "
    if /i "%fallback%"=="y" (
        echo 💻 ติดตั้ง CPU-only version...
        pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cpu
        if errorlevel 1 (
            echo ❌ ERROR: ติดตั้ง CPU version ไม่สำเร็จ
            echo    กรุณาดู troubleshooting guide ใน LLAMA_CPP_PYTHON_TROUBLESHOOTING.md
            pause
            exit /b 1
        )
        set GPU_SUPPORT=false
    ) else (
        echo ❌ ไม่สามารถติดตั้ง llama-cpp-python ได้
        pause
        exit /b 1
    )
)

echo ✅ ติดตั้ง llama-cpp-python สำเร็จ

REM ==================== ทดสอบ llama-cpp-python ====================

echo 🧪 ทดสอบ llama-cpp-python...
python -c "from llama_cpp import Llama; print('✅ llama-cpp-python ทำงานได้!')" 2>nul
if errorlevel 1 (
    echo ❌ WARNING: ทดสอบ import ไม่ผ่าน
    echo    ลองดู error message:
    python -c "from llama_cpp import Llama"
    echo.
    echo 💡 อาจจะใช้งานได้ปกติ หรือต้องแก้ไขเพิ่มเติม
    set /p continue_anyway="ต้องการดำเนินการต่อหรือไม่? (y/n): "
    if /i not "%continue_anyway%"=="y" (
        pause
        exit /b 1
    )
) else (
    echo ✅ llama-cpp-python ทำงานได้ปกติ
)

REM ==================== ติดตั้ง Dependencies อื่นๆ ====================

echo 🔍 [ขั้นตอนที่ 7/8] ติดตั้ง Dependencies อื่นๆ...
echo ------------------------------------------------

echo 📦 ติดตั้ง core packages...
pip install streamlit==1.29.0
if errorlevel 1 echo ⚠️ WARNING: ติดตั้ง streamlit ไม่สำเร็จ

echo 📦 ติดตั้ง langchain packages...
pip install langchain==0.1.20 langchain-community==0.0.38
if errorlevel 1 echo ⚠️ WARNING: ติดตั้ง langchain ไม่สำเร็จ

echo 📦 ติดตั้ง vector store packages...
pip install faiss-cpu==1.7.4 sentence-transformers==2.2.2
if errorlevel 1 echo ⚠️ WARNING: ติดตั้ง vector packages ไม่สำเร็จ

echo 📦 ติดตั้ง document processing packages...
pip install pypdf==3.17.4 python-docx==1.1.0 tiktoken==0.5.2
if errorlevel 1 echo ⚠️ WARNING: ติดตั้ง document packages ไม่สำเร็จ

echo 📦 ติดตั้ง utility packages...
pip install requests==2.31.0 beautifulsoup4==4.12.2 lxml==4.9.3 Pillow==10.1.0 python-dotenv==1.0.0
if errorlevel 1 echo ⚠️ WARNING: ติดตั้ง utility packages ไม่สำเร็จ

echo ✅ ติดตั้ง dependencies เสร็จสิ้น

REM ==================== Final Testing ====================

echo 🔍 [ขั้นตอนที่ 8/8] ทดสอบระบบ...
echo --------------------------------

echo 🧪 ทดสอบ imports...
python -c "
try:
    import streamlit as st
    print('✅ streamlit: OK')
except: print('❌ streamlit: ERROR')

try:
    from langchain_community.llms import LlamaCpp
    print('✅ langchain: OK')
except: print('❌ langchain: ERROR')

try:
    from langchain_community.vectorstores import FAISS
    print('✅ faiss: OK')
except: print('❌ faiss: ERROR')

try:
    from sentence_transformers import SentenceTransformer
    print('✅ sentence-transformers: OK')
except: print('❌ sentence-transformers: ERROR')

try:
    from llama_cpp import Llama
    print('✅ llama-cpp-python: OK')
except Exception as e: print(f'❌ llama-cpp-python: {e}')
"

if "%GPU_SUPPORT%"=="true" (
    echo 🎮 ทดสอบ CUDA...
    python -c "
import torch
print(f'CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'CUDA device: {torch.cuda.get_device_name(0)}')
    print(f'CUDA memory: {torch.cuda.get_device_properties(0).total_memory // 1024**3} GB')
"
)

REM ==================== สรุปผล ====================

echo.
echo 🎉 การติดตั้งเสร็จสิ้น!
echo ==================
echo.
echo 📊 สรุประบบ:
echo    - Python: %PYTHON_VERSION%
if "%GPU_SUPPORT%"=="true" (
    echo    - GPU Support: ✅ Enabled ^(!GPU_NAME!^)
    echo    - Expected Speed: 3000-4000+ tokens/sec
) else (
    echo    - GPU Support: ❌ CPU-only
    echo    - Expected Speed: 2000-2500 tokens/sec
)
echo    - LLM Model Path: C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\
echo    - Embedding Path: C:\AI\embedding-models\all-MiniLM-L6-v2
echo.
echo 📋 ขั้นตอนต่อไป:
echo    1. ตรวจสอบว่า LLM model อยู่ที่ C:\AI\llm\ (รัน download_models_windows.bat)
echo    2. รัน application: streamlit run rag_chatbot.py
echo    3. เปิด browser ไปที่: http://localhost:8501
echo    4. กด "Create chatbot" เพื่อโหลดโมเดล
echo    5. เริ่มใช้งาน RAG chatbot!
echo.
echo 🔧 Troubleshooting:
echo    - หาก import error: ดู LLAMA_CPP_PYTHON_TROUBLESHOOTING.md
echo    - หาก GPU ไม่ทำงาน: ตรวจสอบ CUDA driver และ log message
echo    - หาก ช้า: ตรวจสอบว่าใช้ GPU หรือ CPU (ดู log "assigned to device CUDA0")
echo.

set /p run_app="ต้องการรัน application ตอนนี้หรือไม่? (y/n): "
if /i "%run_app%"=="y" (
    echo 🚀 เริ่มรัน application...
    streamlit run rag_chatbot.py
) else (
    echo 📝 การติดตั้งเสร็จสิ้น รันคำสั่งนี้เพื่อเริ่มใช้งาน:
    echo    streamlit run rag_chatbot.py
)

pause
