@echo off
chcp 65001 >nul
REM Alternative solution: Install CPU-only llama-cpp-python or use different approach
REM วิธีแก้ปัญหาชั่วคราว: ติดตั้งแบบ CPU-only หรือใช้วิธีอื่น

echo 🔄 Alternative llama-cpp-python Installation
echo ============================================

REM เปิดใช้งาน virtual environment
call llm_rag_env\Scripts\activate.bat

echo 📦 ลองติดตั้ง llama-cpp-python จาก alternative sources...

REM Method 1: Try CPU-only pre-compiled wheel
echo 🔍 Method 1: CPU-only wheel from official repository...
pip install --prefer-binary llama-cpp-python --index-url https://pypi.org/simple/ --no-build-isolation
if not errorlevel 1 goto success

REM Method 2: Try older version that might have wheels
echo 🔍 Method 2: Older version with pre-compiled wheels...
pip install llama-cpp-python==0.1.83 --no-cache-dir
if not errorlevel 1 goto success

REM Method 3: Try alternative package (llamacpp-python)
echo 🔍 Method 3: Alternative package...
pip install llamacpp-python
if not errorlevel 1 goto alternative_success

REM Method 4: Use transformers + CPU instead
echo 🔍 Method 4: Fallback to transformers (will be slower)...
pip install transformers torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
if not errorlevel 1 goto transformers_success

echo ❌ ไม่สามารถติดตั้ง llama-cpp-python ได้
echo 💡 แนะนำ:
echo    1. ติดตั้ง Visual Studio Community (มี C++ compiler ครบ)
echo    2. หรือใช้ WSL2 + Ubuntu ซึ่งติดตั้งง่ายกว่า
echo    3. หรือใช้ cloud services เช่น Google Colab
goto end

:success
echo ✅ ติดตั้ง llama-cpp-python สำเร็จ!
echo 🧪 ทดสอบการทำงาน...
python -c "from llama_cpp import Llama; print('✅ llama-cpp-python พร้อมใช้งาน')"
goto install_others

:alternative_success
echo ✅ ติดตั้ง alternative package สำเร็จ!
echo ⚠️ อาจจะต้องแก้ไข import ในโค้ด
goto install_others

:transformers_success
echo ✅ ติดตั้ง transformers สำเร็จ!
echo ⚠️ จะใช้ transformers แทน llama-cpp-python (ช้ากว่าแต่ใช้งานได้)
goto install_others

:install_others
echo 📦 ติดตั้ง packages อื่นๆ...
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers

echo.
echo 🎉 ติดตั้งเสร็จสิ้น!
echo 📋 ขั้นตอนต่อไป:
echo    1. รัน: streamlit run rag_chatbot.py
echo    2. หากมี error เกี่ยวกับ llama-cpp-python ให้แก้ไขโค้ดใช้ transformers แทน

:end
pause
