@echo off
chcp 65001 >nul
REM Installation Menu - เมนูเลือกการติดตั้ง
REM ให้ผู้ใช้เลือกวิธีการติดตั้งที่เหมาะสม

echo 🎯 เมนูการติดตั้ง LLM-RAG สำหรับ Windows
echo ==========================================
echo.
echo 📋 เลือกวิธีการติดตั้งที่เหมาะกับระบบของคุณ:
echo.
echo 1️⃣  ติดตั้งแบบ Smart (แนะนำ)
echo     - ตรวจสอบระบบอัตโนมัติ
echo     - เลือก GPU/CPU ตามความเหมาะสม
echo     - มีตัวเลือกสำรองหากติดตั้งไม่สำเร็จ
echo.
echo 2️⃣  ติดตั้งแบบ CPU-only เท่านั้น
echo     - เสถียร ไม่ต้องการ Visual Studio Build Tools
echo     - เหมาะสำหรับการทดสอบและพัฒนา
echo     - ความเร็วปานกลาง (~2000-2500 tokens/sec)
echo.
echo 3️⃣  ติดตั้งด่วนด้วย Pre-compiled Wheels ⚡ (ใหม่!)
echo     - ไม่ต้อง compile ใช้ wheel ที่ compile แล้ว
echo     - เร็วกว่าแต่อาจไม่ได้ optimization เต็มที่
echo.
echo 4️⃣  ใช้ทางเลือกอื่น (Ollama/Transformers) 🔄 (ใหม่!)
echo     - Ollama: ใช้งานง่าย จัดการโมเดลอัตโนมัติ
echo     - Transformers: เสถียร รองรับโมเดลหลากหลาย
echo.
echo 5️⃣  วินิจฉัยปัญหาก่อนติดตั้ง
echo     - ตรวจสอบระบบและ dependencies
echo     - ให้คำแนะนำการแก้ไข
echo.
echo 6️⃣  แก้ปัญหา FAISS
echo     - แก้ปัญหา FAISS compatibility
echo.
echo 7️⃣  ติดตั้งแบบอื่นๆ (สำหรับผู้เชี่ยวชาญ)
echo     - วิธีการติดตั้งทางเลือก
echo.
echo 0️⃣  ออกจากเมนู
echo.

set /p choice="เลือกหมายเลข (0-7): "

if "%choice%"=="1" (
    echo 🚀 เริ่มติดตั้งแบบ Smart...
    call "%~dp0setup_complete_gpu.bat"
) else if "%choice%"=="2" (
    echo 💻 เริ่มติดตั้งแบบ CPU-only...
    call "%~dp0setup_cpu_only.bat"
) else if "%choice%"=="3" (
    echo ⚡ เริ่มติดตั้งด่วนด้วย Pre-compiled Wheels...
    call "%~dp0quick_install_wheels.bat"
) else if "%choice%"=="4" (
    echo � เริ่มติดตั้งทางเลือกอื่น...
    call "%~dp0install_alternative_llm.bat"
) else if "%choice%"=="5" (
    echo �🔍 เริ่มวินิจฉัยระบบ...
    call "%~dp0diagnose_llama_cpp.bat"
) else if "%choice%"=="6" (
    echo 🔧 แก้ปัญหา FAISS...
    call "%~dp0fix_faiss_windows.bat"
) else if "%choice%"=="7" (
    echo 🛠️ ติดตั้งแบบทางเลือก...
    call "%~dp0install_llama_alternative.bat"
) else if "%choice%"=="0" (
    echo 👋 ออกจากเมนู
    exit /b 0
) else (
    echo ❌ ตัวเลือกไม่ถูกต้อง กรุณาลองใหม่
    pause
    cls
    goto :eof
)

echo.
echo 🏁 เสร็จสิ้นการทำงาน
pause
