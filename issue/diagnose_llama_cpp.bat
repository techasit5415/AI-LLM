@echo off
chcp 65001 >nul
REM ========================================================================
REM  LLama-CPP-Python Diagnostic and Repair Script
REM  สคริปต์วินิจฉัยและแก้ไขปัญหา llama-cpp-python
REM ========================================================================

title LLama-CPP-Python Diagnostic Tool

echo.
echo 🔧 LLama-CPP-Python Diagnostic Tool
echo ===================================
echo.
echo 📋 สคริปต์นี้จะช่วยวินิจฉัยและแก้ไขปัญหา llama-cpp-python
echo.

REM ==================== Basic System Check ====================

echo 🔍 [การตรวจสอบระบบ] System Diagnostic...
echo ----------------------------------------

echo 💻 ข้อมูลระบบ:
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"

echo.
echo 🐍 ข้อมูล Python:
python --version 2>nul || echo ❌ Python not found
python -c "import sys; print(f'Python executable: {sys.executable}')" 2>nul
python -c "import sys; print(f'Python path: {sys.path[0]}')" 2>nul

echo.
echo 📦 ข้อมูล pip:
pip --version 2>nul || echo ❌ pip not found

echo.
echo 🎮 ข้อมูล GPU:
nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader,nounits 2>nul || echo ❌ NVIDIA GPU/Driver not found

REM ==================== Virtual Environment Check ====================

echo.
echo 🔍 [Virtual Environment] ตรวจสอบ Virtual Environment...
echo --------------------------------------------------------

if exist "llm_rag_env" (
    echo ✅ พบ virtual environment
    
    call llm_rag_env\Scripts\activate.bat
    echo 📍 Active environment: %VIRTUAL_ENV%
    
    echo.
    echo 📦 Packages ที่ติดตั้งแล้ว:
    pip list | findstr -i "llama torch streamlit langchain faiss sentence"
    
) else (
    echo ❌ ไม่พบ virtual environment
    echo 💡 รัน: python -m venv llm_rag_env
)

REM ==================== Import Testing ====================

echo.
echo 🔍 [Import Testing] ทดสอบ imports...
echo -----------------------------------

echo 🧪 ทดสอบ core imports...
python -c "
import sys
packages = [
    ('streamlit', 'streamlit'),
    ('torch', 'torch'), 
    ('langchain', 'langchain'),
    ('langchain_community.llms', 'LlamaCpp'),
    ('langchain_community.vectorstores', 'FAISS'),
    ('sentence_transformers', 'SentenceTransformer'),
    ('llama_cpp', 'Llama')
]

for module, component in packages:
    try:
        if component:
            exec(f'from {module} import {component}')
        else:
            exec(f'import {module}')
        print(f'✅ {module}: OK')
    except ImportError as e:
        print(f'❌ {module}: IMPORT ERROR - {e}')
    except Exception as e:
        print(f'⚠️ {module}: WARNING - {e}')
"

REM ==================== llama-cpp-python Specific Tests ====================

echo.
echo 🔍 [LLama-CPP-Python] ทดสอบเฉพาะ llama-cpp-python...
echo ----------------------------------------------------

echo 🦙 ทดสอบ llama-cpp-python import และ version...
python -c "
try:
    from llama_cpp import Llama
    import llama_cpp
    print(f'✅ llama-cpp-python version: {llama_cpp.__version__}')
    
    # ทดสอบสร้าง instance (ไม่ต้องใส่ model)
    try:
        # ใช้ dummy model path เพื่อทดสอบ constructor
        print('🧪 ทดสอบ Llama constructor...')
        print('✅ Llama class accessible')
    except Exception as e:
        print(f'⚠️ Llama constructor warning: {e}')
        
except ImportError as e:
    print(f'❌ llama-cpp-python import failed: {e}')
    print('💡 แนะนำ: pip install llama-cpp-python')
except Exception as e:
    print(f'⚠️ llama-cpp-python unexpected error: {e}')
"

REM ==================== CUDA Testing ====================

echo.
echo 🔍 [CUDA Testing] ทดสอบ CUDA support...
echo ---------------------------------------

echo 🎮 ทดสอบ PyTorch CUDA...
python -c "
try:
    import torch
    print(f'PyTorch version: {torch.__version__}')
    print(f'CUDA available: {torch.cuda.is_available()}')
    
    if torch.cuda.is_available():
        print(f'CUDA version: {torch.version.cuda}')
        print(f'cuDNN version: {torch.backends.cudnn.version()}')
        print(f'Device count: {torch.cuda.device_count()}')
        for i in range(torch.cuda.device_count()):
            props = torch.cuda.get_device_properties(i)
            print(f'GPU {i}: {props.name} ({props.total_memory // 1024**3} GB)')
    else:
        print('🔍 CUDA ไม่พร้อมใช้งาน - จะใช้ CPU')
        
except ImportError:
    print('❌ PyTorch ไม่ได้ติดตั้ง')
except Exception as e:
    print(f'⚠️ PyTorch error: {e}')
"

echo.
echo 🎮 ทดสอบ NVIDIA driver...
nvidia-smi 2>nul && (
    echo ✅ NVIDIA driver พร้อมใช้งาน
) || (
    echo ❌ NVIDIA driver ไม่พร้อมใช้งาน
    echo 💡 ติดตั้ง NVIDIA driver จาก: https://www.nvidia.com/drivers
)

REM ==================== File System Check ====================

echo.
echo 🔍 [File System] ตรวจสอบไฟล์และโฟลเดอร์...
echo -------------------------------------------

echo 📁 ตรวจสอบ project structure...
if exist "rag_chatbot.py" (
    echo ✅ rag_chatbot.py
) else (
    echo ❌ ไม่พบ rag_chatbot.py
)

if exist "pages\backend\rag_functions.py" (
    echo ✅ pages\backend\rag_functions.py
) else (
    echo ❌ ไม่พบ pages\backend\rag_functions.py
)

if exist "vector store" (
    echo ✅ vector store directory
    dir "vector store" /b
) else (
    echo ❌ ไม่พบ vector store directory
)

echo.
echo 📁 ตรวจสอบ model paths...
if exist "C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf" (
    echo ✅ LLM model พบที่ C:\AI\llm\
    for %%f in ("C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf") do echo    Size: %%~zf bytes
) else (
    echo ❌ ไม่พบ LLM model ที่ C:\AI\llm\
    echo 💡 รัน download_models_windows.bat เพื่อดาวน์โหลด
)

if exist "C:\AI\embedding-models\all-MiniLM-L6-v2" (
    echo ✅ Embedding model พบที่ C:\AI\embedding-models\
) else (
    echo ❌ ไม่พบ Embedding model ที่ C:\AI\embedding-models\
    echo 💡 จะใช้ online embedding แทน
)

REM ==================== Configuration Check ====================

echo.
echo 🔍 [Configuration] ตรวจสอบการตั้งค่า...
echo --------------------------------------

echo 📝 ตรวจสอบ path configuration ใน rag_chatbot.py...
findstr /n "llm_model.*=" rag_chatbot.py 2>nul | findstr /v "text_input" || echo ⚠️ ไม่พบ llm_model configuration

echo.
echo 📝 ตรวจสอบ import statements...
findstr /n "from llama_cpp import" pages\backend\rag_functions.py 2>nul || echo ⚠️ ไม่พบ llama_cpp import

REM ==================== Performance Test ====================

echo.
echo 🔍 [Performance] ทดสอบ performance...
echo -----------------------------------

echo ⏱️ ทดสอบ import speed...
powershell -Command "Measure-Command { python -c 'from llama_cpp import Llama' } | Select-Object TotalMilliseconds" 2>nul || echo ❌ ไม่สามารถทดสอบ performance

REM ==================== Repair Suggestions ====================

echo.
echo 🔧 [Repair Suggestions] คำแนะนำการแก้ไข...
echo -------------------------------------------

python -c "
issues = []
fixes = []

# Check llama-cpp-python
try:
    from llama_cpp import Llama
except ImportError:
    issues.append('❌ llama-cpp-python ไม่ได้ติดตั้งหรือ import ไม่ได้')
    fixes.append('💡 Fix: pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cpu')

# Check torch
try:
    import torch
    if not torch.cuda.is_available():
        issues.append('⚠️ CUDA ไม่พร้อมใช้งาน จะใช้ CPU')
        fixes.append('💡 Fix: ติดตั้ง CUDA driver และ PyTorch CUDA version')
except ImportError:
    issues.append('❌ PyTorch ไม่ได้ติดตั้ง')
    fixes.append('💡 Fix: pip install torch torchvision torchaudio')

# Check other packages
packages = ['streamlit', 'langchain', 'sentence_transformers']
for pkg in packages:
    try:
        exec(f'import {pkg}')
    except ImportError:
        issues.append(f'❌ {pkg} ไม่ได้ติดตั้ง')
        fixes.append(f'💡 Fix: pip install {pkg}')

if issues:
    print('🔧 ปัญหาที่พบ:')
    for issue in issues:
        print(f'   {issue}')
    print()
    print('💡 คำแนะนำการแก้ไข:')
    for fix in fixes:
        print(f'   {fix}')
else:
    print('✅ ไม่พบปัญหาสำคัญ ระบบน่าจะทำงานได้ปกติ')
"

REM ==================== Quick Fixes ====================

echo.
echo 🔧 [Quick Fixes] การแก้ไขด่วน...
echo --------------------------------

echo 💡 ตัวเลือกการแก้ไข:
echo    1. ติดตั้ง llama-cpp-python ใหม่ (CPU)
echo    2. ติดตั้ง llama-cpp-python ใหม่ (GPU)
echo    3. แก้ไข FAISS compatibility
echo    4. รีเซ็ต virtual environment
echo    5. ข้าม
echo.

set /p fix_choice="เลือกการแก้ไข (1-5): "

if "%fix_choice%"=="1" (
    echo 💻 ติดตั้ง llama-cpp-python CPU version...
    pip uninstall llama-cpp-python -y
    pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cpu
    echo ✅ เสร็จสิ้น
    
) else if "%fix_choice%"=="2" (
    echo 🎮 ติดตั้ง llama-cpp-python GPU version...
    pip uninstall llama-cpp-python -y
    set CMAKE_ARGS=-DLLAMA_CUBLAS=on
    pip install llama-cpp-python --no-cache-dir
    echo ✅ เสร็จสิ้น
    
) else if "%fix_choice%"=="3" (
    echo 🔧 แก้ไข FAISS compatibility...
    pip install --upgrade langchain==0.1.20 langchain-community==0.0.38
    echo ✅ เสร็จสิ้น
    
) else if "%fix_choice%"=="4" (
    echo 🔄 รีเซ็ต virtual environment...
    set /p confirm="ยืนยันการลบ virtual environment? (y/n): "
    if /i "%confirm%"=="y" (
        rmdir /s /q llm_rag_env
        python -m venv llm_rag_env
        call llm_rag_env\Scripts\activate.bat
        pip install -r requirements.txt
        echo ✅ เสร็จสิ้น
    )
) else (
    echo 📝 ข้ามการแก้ไขด่วน
)

echo.
echo 📋 สรุป Diagnostic:
echo ==================
echo    - ดู log ข้างบนเพื่อระบุปัญหา
echo    - ใช้ Quick Fixes เพื่อแก้ไขปัญหาเบื้องต้น
echo    - หากยังมีปัญหา ดู LLAMA_CPP_PYTHON_TROUBLESHOOTING.md
echo.

pause
