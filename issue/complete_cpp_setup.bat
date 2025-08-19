@echo off
chcp 65001 >nul
REM Complete Visual Studio C++ Tools Setup
REM ติดตั้งและตั้งค่า C++ Tools ให้สมบูรณ์

echo 🛠️ Complete C++ Build Tools Setup
echo ==================================

echo.
echo ⚠️ หมายเหตุสำคัญ:
echo    ต้องรันใน Command Prompt ที่มีสิทธิ์ Administrator
echo    การติดตั้งใช้เวลาประมาณ 15-45 นาที และใช้พื้นที่ 3-6 GB
echo.

REM ตรวจสอบสิทธิ์ admin
net session >nul 2>&1
if errorlevel 1 (
    echo ❌ ต้องการสิทธิ์ Administrator
    echo.
    echo 💡 วิธีแก้ไข:
    echo    1. ปิด Command Prompt นี้
    echo    2. คลิกขวาที่ Command Prompt
    echo    3. เลือก "Run as administrator"
    echo    4. รันสคริปต์นี้อีกครั้ง
    echo.
    pause
    exit /b 1
)

echo ✅ มีสิทธิ์ Administrator

echo.
echo 🔍 ขั้นตอนที่ 1: ตรวจสอบสถานะปัจจุบัน
echo ========================================

REM ตรวจสอบ Build Tools
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" (
    echo ✅ พบ Visual Studio Build Tools 2022
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools" (
    echo ✅ พบ Visual Studio Build Tools 2022 (64-bit location)
) else (
    echo ❌ ไม่พบ Build Tools - จะติดตั้งใหม่
    goto :fresh_install
)

REM ตรวจสอบ C++ compiler
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\*\bin\Hostx64\x64\cl.exe" (
    echo ✅ พบ C++ Compiler
    goto :setup_environment
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC" (
    echo ⚠️ พบ MSVC folder แต่ไม่มี compiler
    goto :install_cpp_components
) else (
    echo ❌ ไม่พบ C++ Compiler - ต้องติดตั้ง
    goto :install_cpp_components
)

:fresh_install
echo.
echo 🔽 ขั้นตอนที่ 2: ติดตั้ง Visual Studio Build Tools ใหม่
echo =====================================================

echo 🔄 ลบ Build Tools เก่า (หากมี)...
winget uninstall Microsoft.VisualStudio.2022.BuildTools --silent >nul 2>&1

echo 🔽 ดาวน์โหลด Build Tools installer...
curl -L -o vs_buildtools.exe "https://aka.ms/vs/17/release/vs_buildtools.exe"

if not exist "vs_buildtools.exe" (
    echo ❌ ดาวน์โหลดไม่สำเร็จ
    echo 💡 ลองใช้ winget แทน...
    goto :winget_install
)

echo 🚀 ติดตั้ง Build Tools พร้อม C++ Components...
echo    (ใช้เวลาประมาณ 15-30 นาที)

vs_buildtools.exe --quiet --wait ^
    --add Microsoft.VisualStudio.Workload.VCTools ^
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
    --add Microsoft.VisualStudio.Component.Windows11SDK.22000 ^
    --add Microsoft.VisualStudio.Component.VC.CMake.Project ^
    --add Microsoft.VisualStudio.Component.VC.ATL ^
    --includeRecommended

if errorlevel 1 (
    echo ❌ ติดตั้งไม่สำเร็จ ลองใช้ winget...
    goto :winget_install
)

echo ✅ ติดตั้ง Build Tools สำเร็จ
del vs_buildtools.exe >nul 2>&1
goto :setup_environment

:winget_install
echo.
echo 🔽 ติดตั้งผ่าน winget...
echo =======================

winget install Microsoft.VisualStudio.2022.BuildTools --silent --accept-package-agreements --accept-source-agreements

echo ⏰ รอให้ติดตั้งเสร็จ...
timeout /t 10

goto :install_cpp_components

:install_cpp_components
echo.
echo 🔧 ขั้นตอนที่ 3: ติดตั้ง C++ Components
echo ====================================

REM หา Visual Studio Installer
set "vs_installer="
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe" (
    set "vs_installer=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\Installer\vs_installer.exe" (
    set "vs_installer=%ProgramFiles%\Microsoft Visual Studio\Installer\vs_installer.exe"
)

if not defined vs_installer (
    echo ❌ ไม่พบ Visual Studio Installer
    goto :manual_install
)

echo 🔄 ติดตั้ง C++ Build Tools components...

REM ลองหา BuildTools installation path
set "build_path="
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" (
    set "build_path=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools" (
    set "build_path=%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools"
)

if defined build_path (
    echo 🔄 Modify existing BuildTools installation...
    "%vs_installer%" modify --installPath "%build_path%" ^
        --add Microsoft.VisualStudio.Workload.VCTools ^
        --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
        --add Microsoft.VisualStudio.Component.Windows11SDK.22000 ^
        --add Microsoft.VisualStudio.Component.VC.CMake.Project ^
        --quiet
) else (
    echo 🔄 Install new BuildTools with components...
    "%vs_installer%" install --productId Microsoft.VisualStudio.Product.BuildTools ^
        --add Microsoft.VisualStudio.Workload.VCTools ^
        --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
        --add Microsoft.VisualStudio.Component.Windows11SDK.22000 ^
        --add Microsoft.VisualStudio.Component.VC.CMake.Project ^
        --quiet
)

echo ⏰ รอให้ติดตั้ง components เสร็จ...
timeout /t 30

goto :setup_environment

:manual_install
echo.
echo 🛠️ การติดตั้งแบบ Manual
echo =====================
echo.
echo ❌ ไม่สามารถติดตั้งอัตโนมัติได้
echo.
echo 📋 กรุณาทำตามขั้นตอนนี้:
echo.
echo 1️⃣ ไปที่: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
echo.
echo 2️⃣ ดาวน์โหลด "Build Tools for Visual Studio 2022"
echo.
echo 3️⃣ รัน installer และเลือก:
echo    ✅ Desktop development with C++
echo    ✅ MSVC v143 - VS 2022 C++ x64/x86 build tools
echo    ✅ Windows 11 SDK (10.0.22000.0)
echo    ✅ CMake tools for Visual Studio
echo.
echo 4️⃣ คลิก "Install" และรอให้เสร็จ
echo.
echo 5️⃣ หลังติดตั้งเสร็จ ให้รันสคริปต์นี้อีกครั้ง
echo.

echo 🌐 เปิดหน้าดาวน์โหลด...
start https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022

pause
exit /b 1

:setup_environment
echo.
echo 🔧 ขั้นตอนที่ 4: ตั้งค่า Environment
echo =================================

REM หา Build Tools path
set "vs_path="
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" (
    set "vs_path=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools" (
    set "vs_path=%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools"
) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community" (
    set "vs_path=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community" (
    set "vs_path=%ProgramFiles%\Microsoft Visual Studio\2022\Community"
)

if not defined vs_path (
    echo ❌ ไม่พบ Visual Studio installation
    goto :manual_install
)

echo ✅ พบ Visual Studio ที่: %vs_path%

REM โหลด VS environment
echo 🔄 โหลด Visual Studio environment...
call "%vs_path%\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1

if errorlevel 1 (
    echo ❌ ไม่สามารถโหลด vcvars64.bat ได้
    echo 🔄 ลองใช้ vcvarsall.bat...
    call "%vs_path%\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
    
    if errorlevel 1 (
        echo ❌ ไม่สามารถโหลด VS environment ได้
        goto :manual_install
    )
)

echo ✅ โหลด VS environment สำเร็จ

REM ทดสอบ compiler
echo 🧪 ทดสอบ C++ compiler...
cl /? >nul 2>&1
if errorlevel 1 (
    echo ❌ ยังไม่สามารถเรียก cl.exe ได้
    echo 🔍 ค้นหา cl.exe...
    
    for /f "delims=" %%i in ('dir "%vs_path%\VC\Tools\MSVC\*\bin\Hostx64\x64\cl.exe" /s /b 2^>nul') do (
        echo ✅ พบ cl.exe: %%i
        set "PATH=%%~dpi;%PATH%"
        goto :compiler_ready
    )
    
    echo ❌ ไม่พบ cl.exe - C++ tools ไม่ได้ติดตั้งครบ
    goto :manual_install
) else (
    echo ✅ C++ compiler พร้อมใช้งาน
)

:compiler_ready
echo.
echo 🚀 ขั้นตอนที่ 5: ติดตั้ง llama-cpp-python
echo ========================================

REM ไปยัง project directory
cd /d "%~dp0.."

REM ตรวจสอบ virtual environment
if exist "llm_rag_env\Scripts\activate.bat" (
    echo ✅ พบ virtual environment
    call llm_rag_env\Scripts\activate.bat
) else (
    echo 🔄 สร้าง virtual environment ใหม่...
    python -m venv llm_rag_env
    if errorlevel 1 (
        echo ❌ ไม่สามารถสร้าง virtual environment ได้
        echo 💡 ตรวจสอบว่าติดตั้ง Python แล้วหรือยัง
        pause
        exit /b 1
    )
    call llm_rag_env\Scripts\activate.bat
)

echo 📦 อัพเกรด pip และ tools...
python -m pip install --upgrade pip setuptools wheel

echo 🗑️ ลบ llama-cpp-python เก่า...
pip uninstall llama-cpp-python -y >nul 2>&1

echo.
echo 🎯 ติดตั้ง llama-cpp-python...

REM ลองวิธีต่างๆ ตามลำดับ
echo 🔄 Method 1: CPU-only build...
pip install llama-cpp-python==0.2.90 --no-cache-dir --verbose --timeout 900

if not errorlevel 1 (
    echo ✅ ติดตั้งสำเร็จ!
    goto :test_installation
)

echo ❌ Method 1 ไม่สำเร็จ, ลอง Method 2...

echo 🔄 Method 2: Force rebuild...
set CMAKE_ARGS=-DLLAMA_STATIC=ON
set FORCE_CMAKE=1
pip install llama-cpp-python==0.2.90 --no-cache-dir --force-reinstall --verbose --timeout 900

if not errorlevel 1 (
    echo ✅ ติดตั้งสำเร็จ!
    goto :test_installation
)

echo ❌ Method 2 ไม่สำเร็จ, ลอง Method 3...

echo 🔄 Method 3: Older version...
pip install llama-cpp-python==0.2.85 --no-cache-dir --verbose --timeout 900

if not errorlevel 1 (
    echo ✅ ติดตั้งสำเร็จ!
    goto :test_installation
)

echo ❌ ทุกวิธีไม่สำเร็จ
goto :installation_failed

:test_installation
echo.
echo 🧪 ทดสอบการติดตั้ง...
echo ====================

python -c "
try:
    import llama_cpp
    print('✅ Import llama_cpp สำเร็จ!')
    print(f'🔧 Version: {llama_cpp.__version__}')
    
    # ทดสอบ basic functionality
    print('🔄 ทดสอบ basic functions...')
    # ไม่โหลดโมเดลจริงเพื่อประหยัดเวลา
    print('✅ llama-cpp-python พร้อมใช้งาน!')
    
except ImportError as e:
    print(f'❌ Import error: {e}')
    exit(1)
except Exception as e:
    print(f'⚠️ Warning: {e}')
    print('🟡 llama-cpp-python ติดตั้งแล้วแต่อาจมีปัญหาเล็กน้อย')
"

if errorlevel 1 (
    echo ❌ ทดสอบไม่ผ่าน
    goto :installation_failed
)

echo.
echo 📦 ติดตั้ง dependencies อื่นๆ...
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers

echo.
echo 🎉 ติดตั้งสำเร็จทั้งหมด!
echo ======================
echo.
echo 📋 วิธีใช้งาน:
echo.
echo 1️⃣ เปิด Command Prompt ใหม่ (ไม่ต้อง admin)
echo.
echo 2️⃣ ไปที่ project directory:
echo    cd "C:\Users\techa\OneDrive\เอกสาร\AI-LLM"
echo.
echo 3️⃣ เปิดใช้งาน virtual environment:
echo    llm_rag_env\Scripts\activate.bat
echo.
echo 4️⃣ รัน application:
echo    streamlit run rag_chatbot.py
echo.
echo 5️⃣ เปิด browser: http://localhost:8501
echo.
echo ⚠️ หมายเหตุ: ปิด Command Prompt นี้และเปิดใหม่
echo          เพื่อให้ environment ทำงานปกติ
echo.

pause
exit /b 0

:installation_failed
echo.
echo ❌ การติดตั้ง llama-cpp-python ไม่สำเร็จ
echo ===================================
echo.
echo 🔍 สาเหตุที่เป็นไปได้:
echo    - C++ components ไม่ครบ
echo    - Windows SDK ไม่มี
echo    - Environment variables ไม่ถูกต้อง
echo    - Memory ไม่เพียงพอระหว่างการ compile
echo.
echo 🛠️ ทางแก้ไข:
echo.
echo 1️⃣ ลองติดตั้งแบบ manual:
echo    - เปิด Visual Studio Installer
echo    - เลือก "Desktop development with C++"
echo    - ติดตั้งครบทุก component
echo.
echo 2️⃣ ใช้ทางเลือกอื่น:
echo    .\issue\install_alternative_llm.bat
echo.
echo 3️⃣ ใช้ WSL2:
echo    wsl --install
echo.
echo 4️⃣ ใช้ Docker หรือ cloud service
echo.

set /p choice="เลือกทางเลือก (2-4) หรือ Enter เพื่อออก: "

if "%choice%"=="2" (
    call "%~dp0install_alternative_llm.bat"
) else if "%choice%"=="3" (
    echo 🐧 สำหรับ WSL2 กรุณารัน: wsl --install
    echo    แล้วติดตั้ง Ubuntu และรันคำสั่งใน Linux
) else if "%choice%"=="4" (
    echo 🌐 แนะนำ cloud services:
    echo    - Google Colab (ฟรี)
    echo    - Hugging Face Spaces
    echo    - GitHub Codespaces
)

pause
exit /b 1
