@echo off
chcp 65001 >nul
REM Installation Menu - เมนูเลือกการติดตั้งแบบเรียบง่าย
REM ให้ผู้ใช้เลือกวิธีการติดตั้งที่เหมาะสม

echo 🎯 เมนูการติดตั้ง LLM-RAG สำหรับ Windows
echo ==========================================
echo.
echo 📋 เลือกวิธีการติดตั้งที่เหมาะกับระบบของคุณ:
echo.
echo 1️⃣  ติดตั้งแบบ Smart (GPU/CPU อัตโนมัติ)
echo     - ตรวจสอบระบบอัตโนมัติ
echo     - เลือก GPU หรือ CPU ตามความเหมาะสม
echo     - มีตัวเลือกสำรองหากติดตั้งไม่สำเร็จ
echo.
echo 2️⃣  ติดตั้งแบบ CPU-only เท่านั้น
echo     - เสถียร ต้องการ Visual Studio Build Tools
echo     - เหมาะสำหรับการทดสอบและพัฒนา
echo     - ความเร็วปานกลาง (~2000-2500 tokens/sec)
echo.
echo 3️⃣  ใช้ทางเลือกอื่น (Ollama/Transformers)
echo     - Ollama: ใช้งานง่าย จัดการโมเดลอัตโนมัติ
echo     - Transformers: เสถียร รองรับโมเดลหลากหลาย
echo     - ไม่ต้องการ Visual Studio Build Tools
echo.
echo 4️⃣  ติดตั้ง Visual Studio Build Tools แบบสมบูรณ์
echo     - ติดตั้ง C++ Tools ครบชุด (ต้องการ Admin)
echo     - รองรับการติดตั้งแบบ step-by-step
echo     - แก้ปัญหาการติดตั้งที่ไม่ครบ
echo.
echo 5️⃣  แก้ปัญหาหลังติดตั้ง Build Tools
echo     - สำหรับที่ติดตั้ง Build Tools แล้วแต่ยังใช้ไม่ได้
echo     - ตั้งค่า C++ environment ใหม่
echo.
echo 6️⃣  วินิจฉัยปัญหาระบบ
echo     - ตรวจสอบระบบและ dependencies
echo     - ให้คำแนะนำการแก้ไข
echo.
echo 0️⃣  ออกจากเมนู
echo.

set /p choice="เลือกหมายเลข (0-6): "

if "%choice%"=="1" (
    echo 🚀 เริ่มติดตั้งแบบ Smart...
    call "%~dp0setup_complete_gpu.bat"
) else if "%choice%"=="2" (
    echo 💻 เริ่มติดตั้งแบบ CPU-only...
    call "%~dp0setup_cpu_only.bat"
) else if "%choice%"=="3" (
    echo 🔄 เริ่มติดตั้งทางเลือกอื่น...
    call "%~dp0install_alternative_llm.bat"
) else if "%choice%"=="4" (
    echo 🛠️ ติดตั้ง C++ Tools แบบสมบูรณ์...
    call "%~dp0complete_cpp_setup.bat"
) else if "%choice%"=="5" (
    echo 🔧 แก้ปัญหาหลังติดตั้ง Build Tools...
    call "%~dp0fix_buildtools_installation.bat"
) else if "%choice%"=="6" (
    echo 🔍 เริ่มวินิจฉัยระบบ...
    call "%~dp0diagnose_llama_cpp.bat"
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
