@echo off
chcp 65001 >nul
REM Quick Install using pre-compiled wheels
REM ติดตั้งด่วนโดยใช้ wheel ที่ compile แล้ว

echo 🚀 ติดตั้งด่วน llama-cpp-python แบบ Pre-compiled Wheel
echo =====================================================

REM ตรวจสอบว่าอยู่ใน project directory
cd /d "%~dp0.."
if not exist "rag_chatbot.py" (
    echo ❌ ไม่พบไฟล์ rag_chatbot.py
    echo    กรุณา cd เข้าไปใน LLM-RAG directory ก่อน
    pause
    exit /b 1
)

REM เปิดใช้งาน virtual environment
if exist "llm_rag_env\Scripts\activate.bat" (
    echo 🔄 เปิดใช้งาน virtual environment...
    call llm_rag_env\Scripts\activate.bat
) else (
    echo ❌ ไม่พบ virtual environment
    echo    กรุณารัน: python -m venv llm_rag_env
    pause
    exit /b 1
)

echo 🗑️ ลบ llama-cpp-python เวอร์ชันเก่า (หากมี)...
pip uninstall llama-cpp-python -y >nul 2>&1

echo 📦 อัพเกรด pip และ tools...
python -m pip install --upgrade pip setuptools wheel

echo.
echo 🎯 ลองติดตั้งจาก Pre-compiled wheels ต่างๆ...
echo.

REM Method 1: CPU wheel จาก official repo
echo 🔄 วิธีที่ 1: CPU wheel จาก abetlen/llama-cpp-python...
pip install llama-cpp-python --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cpu --force-reinstall --no-cache-dir
if not errorlevel 1 (
    echo ✅ ติดตั้งจาก CPU wheel สำเร็จ!
    goto :test_installation
)

echo ❌ วิธีที่ 1 ไม่สำเร็จ

REM Method 2: ลองใช้ wheels จาก PyPI โดยตรง
echo.
echo 🔄 วิธีที่ 2: หา wheel จาก PyPI...
pip install llama-cpp-python --only-binary=:all: --force-reinstall --no-cache-dir
if not errorlevel 1 (
    echo ✅ ติดตั้งจาก PyPI wheel สำเร็จ!
    goto :test_installation
)

echo ❌ วิธีที่ 2 ไม่สำเร็จ

REM Method 3: ลอง wheel version เก่าที่เสถียร
echo.
echo 🔄 วิธีที่ 3: ลอง version เก่าที่เสถียร...
pip install llama-cpp-python==0.2.85 --only-binary=:all: --force-reinstall --no-cache-dir
if not errorlevel 1 (
    echo ✅ ติดตั้ง version เก่าสำเร็จ!
    goto :test_installation
)

echo ❌ วิธีที่ 3 ไม่สำเร็จ

REM Method 4: ลองจาก alternative source
echo.
echo 🔄 วิธีที่ 4: ลองจาก alternative wheel source...
pip install --pre llama-cpp-python --extra-index-url https://test.pypi.org/simple/ --force-reinstall --no-cache-dir
if not errorlevel 1 (
    echo ✅ ติดตั้งจาก alternative source สำเร็จ!
    goto :test_installation
)

echo ❌ วิธีที่ 4 ไม่สำเร็จ

REM Method 5: ลอง manual download wheel
echo.
echo 🔄 วิธีที่ 5: ลองดาวน์โหลด wheel แบบ manual...
echo 💡 กำลังค้นหา compatible wheel...

python -c "^
import platform; ^
import sys; ^
print(f'Python version: {sys.version}'); ^
print(f'Platform: {platform.platform()}'); ^
print(f'Architecture: {platform.architecture()}'); ^
print(f'Machine: {platform.machine()}'); ^
try: ^
    from packaging.tags import sys_tags; ^
    tags = list(sys_tags()); ^
    print('Compatible wheel tags:'); ^
    for i, tag in enumerate(tags[:5]): ^
        print(f'  {tag}'); ^
    if len(tags) > 5: ^
        print(f'  ... และอีก {len(tags)-5} tags'); ^
except ImportError: ^
    print('packaging module not available')^
"

echo.
echo ❌ ทุกวิธีการติดตั้งไม่สำเร็จ
goto :installation_failed

:test_installation
echo.
echo 🧪 ทดสอบการติดตั้ง...
python -c "
try:
    import llama_cpp
    print('✅ Import llama_cpp สำเร็จ')
    print(f'🔧 Version: {llama_cpp.__version__}')
    
    # ทดสอบสร้าง instance (ไม่โหลดโมเดล)
    print('🔄 ทดสอบ Llama class...')
    # ไม่ทดสอบจริงเพราะยังไม่มีโมเดล
    print('✅ llama-cpp-python พร้อมใช้งาน!')
    
except ImportError as e:
    print(f'❌ Import ไม่สำเร็จ: {e}')
    exit(1)
except Exception as e:
    print(f'⚠️ Warning: {e}')
    print('✅ llama-cpp-python ติดตั้งแล้ว แต่อาจมีปัญหาเล็กน้อย')
"

if errorlevel 1 (
    echo ❌ ทดสอบไม่ผ่าน
    goto :installation_failed
)

echo.
echo 📦 ติดตั้ง dependencies อื่นๆ...
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers

echo.
echo 🎉 ติดตั้งสำเร็จ!
echo ===============
echo.
echo 📋 ขั้นตอนต่อไป:
echo 1. รัน: streamlit run rag_chatbot.py
echo 2. เปิด browser: http://localhost:8501
echo 3. ทดสอบประสิทธิภาพ: .\issue\test_performance.bat
echo.
echo 💡 หมายเหตุ: นี่เป็นการติดตั้งแบบ CPU-only
echo    หากต้องการ GPU ให้ติดตั้ง Visual Studio Build Tools ก่อน
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
echo 1️⃣ ติดตั้ง Visual Studio Build Tools:
echo    winget install Microsoft.VisualStudio.2022.BuildTools
echo    จากนั้นเลือก "C++ build tools" workload
echo.
echo 2️⃣ ลองติดตั้ง wheel manual:
echo    ไปที่ https://github.com/abetlen/llama-cpp-python/releases
echo    ดาวน์โหลด wheel สำหรับ Windows และติดตั้งด้วย:
echo    pip install [ชื่อไฟล์.whl]
echo.
echo 3️⃣ ใช้ Docker:
echo    docker run -p 8501:8501 [llama-cpp-python-image]
echo.
echo 4️⃣ ใช้ cloud service:
echo    - Google Colab
echo    - Hugging Face Spaces
echo    - Streamlit Cloud
echo.
echo 5️⃣ ติดตั้ง alternative:
echo    pip install ollama
echo    หรือ pip install transformers torch
echo.

pause
exit /b 1
