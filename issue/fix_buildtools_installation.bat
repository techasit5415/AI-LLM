@echo off
chcp 65001 >nul
REM Post Build Tools Installation Fix
REM แก้ไขปัญหาหลังติดตั้ง Visual Studio Build Tools แล้ว

echo 🔧 แก้ไขปัญหาหลังติดตั้ง Visual Studio Build Tools
echo =============================================

echo.
echo 🔍 ขั้นตอนที่ 1: ตรวจสอบการติดตั้ง Build Tools
echo ===============================================

REM ตรวจสอบ Visual Studio Build Tools
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC" (
    echo ✅ พบ Visual Studio Build Tools 2022
    dir "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC" /B
) else (
    echo ❌ ไม่พบ Build Tools ใน Program Files (x86)
    if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC" (
        echo ✅ พบ Build Tools ใน Program Files
        dir "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC" /B
    ) else (
        echo ❌ ไม่พบ Build Tools เลย
        goto :install_missing_components
    )
)

REM ตรวจสอบ C++ Workload
echo.
echo 🔍 ตรวจสอบ C++ Build Tools Workload...
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\*\bin\Hostx64\x64\cl.exe" (
    echo ✅ พบ MSVC Compiler (cl.exe)
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\*\bin\Hostx64\x64\cl.exe" (
    echo ✅ พบ MSVC Compiler (cl.exe)
) else (
    echo ❌ ไม่พบ MSVC Compiler - ต้องติดตั้ง C++ workload
    goto :install_cpp_workload
)

REM ตรวจสอบ Windows SDK
echo.
echo 🔍 ตรวจสอบ Windows SDK...
if exist "%ProgramFiles(x86)%\Windows Kits\10\Include" (
    echo ✅ พบ Windows SDK 10
    dir "%ProgramFiles(x86)%\Windows Kits\10\Include" /B | findstr "10.0"
) else (
    echo ❌ ไม่พบ Windows SDK - ต้องติดตั้ง
    goto :install_windows_sdk
)

REM ตรวจสอบ CMake
echo.
echo 🔍 ตรวจสอบ CMake...
cmake --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ไม่พบ CMake - กำลังติดตั้ง...
    winget install Kitware.CMake --silent
    echo ✅ ติดตั้ง CMake เสร็จแล้ว
) else (
    for /f "tokens=3" %%v in ('cmake --version 2^>^&1 ^| find "cmake version"') do echo ✅ CMake version %%v
)

echo.
echo 🔧 ขั้นตอนที่ 2: ตั้งค่า Environment Variables
echo =============================================

REM หา Visual Studio installation path
set "VS_PATH="
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" (
    set "VS_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools" (
    set "VS_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools"
) else if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community" (
    set "VS_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community" (
    set "VS_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Community"
)

if defined VS_PATH (
    echo ✅ พบ Visual Studio ที่: %VS_PATH%
    
    echo 🔄 กำลังโหลด VS environment...
    call "%VS_PATH%\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1
    
    if errorlevel 1 (
        echo ❌ ไม่สามารถโหลด VS environment ได้
        echo 💡 ลองใช้ vcvarsall.bat แทน...
        call "%VS_PATH%\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
    )
    
    echo ✅ โหลด VS environment สำเร็จ
) else (
    echo ❌ ไม่พบ Visual Studio installation
    goto :manual_setup
)

REM ตรวจสอบ environment variables
echo.
echo 🔍 ตรวจสอบ Environment Variables...
if defined VCINSTALLDIR (
    echo ✅ VCINSTALLDIR: %VCINSTALLDIR%
) else (
    echo ❌ ไม่มี VCINSTALLDIR
)

if defined WindowsSdkDir (
    echo ✅ WindowsSdkDir: %WindowsSdkDir%
) else (
    echo ❌ ไม่มี WindowsSdkDir
)

REM ทดสอบ compiler
echo.
echo 🧪 ทดสอบ C++ Compiler...
cl /? >nul 2>&1
if errorlevel 1 (
    echo ❌ ไม่สามารถเรียก cl.exe ได้
    echo 🔄 ลองหา cl.exe manual...
    
    for /f "delims=" %%i in ('dir "%VS_PATH%\VC\Tools\MSVC\*\bin\Hostx64\x64\cl.exe" /s /b 2^>nul') do (
        echo ✅ พบ cl.exe ที่: %%i
        set "PATH=%%~dpi;%PATH%"
        goto :compiler_found
    )
    
    echo ❌ ไม่พบ cl.exe
    goto :install_cpp_workload
    
    :compiler_found
    echo ✅ เพิ่ม compiler path แล้ว
) else (
    echo ✅ C++ Compiler พร้อมใช้งาน
)

echo.
echo 🚀 ขั้นตอนที่ 3: ทดสอบติดตั้ง llama-cpp-python
echo ===============================================

REM ไปยัง project directory
cd /d "%~dp0.."

REM เปิดใช้งาน virtual environment
if exist "llm_rag_env\Scripts\activate.bat" (
    call llm_rag_env\Scripts\activate.bat
    echo ✅ เปิดใช้งาน virtual environment แล้ว
) else (
    echo 🔄 สร้าง virtual environment ใหม่...
    python -m venv llm_rag_env
    call llm_rag_env\Scripts\activate.bat
)

echo 📦 อัพเกรด tools...
python -m pip install --upgrade pip setuptools wheel

echo 🗑️ ลบ llama-cpp-python เก่า...
pip uninstall llama-cpp-python -y >nul 2>&1

echo.
echo 🎯 ลองติดตั้ง llama-cpp-python แบบต่างๆ...
echo ==========================================

REM Method 1: CPU only แบบ simple
echo 🔄 Method 1: CPU-only simple build...
set CMAKE_ARGS=
set FORCE_CMAKE=
pip install llama-cpp-python==0.2.90 --no-cache-dir --verbose --timeout 600

if not errorlevel 1 (
    echo ✅ Method 1 สำเร็จ!
    goto :test_installation
)

echo ❌ Method 1 ไม่สำเร็จ

REM Method 2: CPU แบบ force cmake
echo.
echo 🔄 Method 2: CPU with force cmake...
set CMAKE_ARGS=-DLLAMA_BLAS=ON -DLLAMA_BLAS_VENDOR=OpenBLAS
set FORCE_CMAKE=1
pip install llama-cpp-python==0.2.90 --no-cache-dir --verbose --timeout 600

if not errorlevel 1 (
    echo ✅ Method 2 สำเร็จ!
    goto :test_installation
)

echo ❌ Method 2 ไม่สำเร็จ

REM Method 3: ใช้ wheel จาก official repo
echo.
echo 🔄 Method 3: Official pre-compiled wheel...
pip install llama-cpp-python --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cpu --force-reinstall --no-cache-dir

if not errorlevel 1 (
    echo ✅ Method 3 สำเร็จ!
    goto :test_installation
)

echo ❌ Method 3 ไม่สำเร็จ

REM Method 4: ลอง version เก่า
echo.
echo 🔄 Method 4: Older stable version...
pip install llama-cpp-python==0.2.85 --no-cache-dir --verbose

if not errorlevel 1 (
    echo ✅ Method 4 สำเร็จ!
    goto :test_installation
)

echo ❌ Method 4 ไม่สำเร็จ

REM Method 5: Build from source แบบ minimal
echo.
echo 🔄 Method 5: Minimal build from source...
pip install scikit-build-core[pyproject] cmake ninja
set CMAKE_ARGS=-DLLAMA_STATIC=ON
pip install llama-cpp-python --no-binary llama-cpp-python --no-cache-dir --verbose

if not errorlevel 1 (
    echo ✅ Method 5 สำเร็จ!
    goto :test_installation
)

echo ❌ ทุก method ไม่สำเร็จ
goto :show_alternatives

:test_installation
echo.
echo 🧪 ทดสอบการติดตั้ง...
python -c "
try:
    import llama_cpp
    print('✅ Import สำเร็จ!')
    print(f'Version: {llama_cpp.__version__}')
    print('🎉 llama-cpp-python พร้อมใช้งาน!')
except Exception as e:
    print(f'❌ ทดสอบไม่สำเร็จ: {e}')
    exit(1)
"

if errorlevel 1 (
    goto :show_alternatives
)

echo.
echo 📦 ติดตั้ง dependencies อื่นๆ...
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers

echo.
echo 🎉 ติดตั้งสำเร็จทั้งหมด!
echo ======================
echo.
echo 📋 การใช้งาน:
echo   streamlit run rag_chatbot.py
echo.
goto :end

:install_missing_components
echo.
echo 🔧 ติดตั้ง Visual Studio Build Tools components ที่ขาดหาย...
echo ==========================================================

echo 🔄 ติดตั้ง Build Tools พร้อม C++ workload...
winget install Microsoft.VisualStudio.2022.BuildTools --override "--quiet --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000"

echo ⏰ รอสักครู่แล้วลองใหม่...
timeout /t 10
goto :manual_setup

:install_cpp_workload
echo.
echo 🔧 ติดตั้ง C++ Build Tools Workload...
echo ===================================

set "vs_installer="
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe" (
    set "vs_installer=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe"
) else if exist "%ProgramFiles%\Microsoft Visual Studio\Installer\vs_installer.exe" (
    set "vs_installer=%ProgramFiles%\Microsoft Visual Studio\Installer\vs_installer.exe"
)

if defined vs_installer (
    echo 🔄 เปิด Visual Studio Installer...
    "%vs_installer%" modify --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000 --quiet
    
    echo ⏰ รอสักครู่แล้วลองใหม่...
    timeout /t 30
) else (
    echo ❌ ไม่พบ Visual Studio Installer
    goto :manual_setup
)

goto :manual_setup

:install_windows_sdk
echo.
echo 🔧 ติดตั้ง Windows SDK...
echo ========================

winget install Microsoft.WindowsSDK.10 --silent
echo ⏰ รอสักครู่แล้วลองใหม่...
timeout /t 10
goto :manual_setup

:show_alternatives
echo.
echo ❌ ไม่สามารถติดตั้ง llama-cpp-python ได้
echo ===================================
echo.
echo 🔄 ทางเลือกอื่น:
echo.
echo 1️⃣ ใช้ Ollama (แนะนำ):
echo    - ดาวน์โหลด: https://ollama.com/download
echo    - รัน: ollama pull llama3.2:3b
echo    - แก้ไขโค้ดให้ใช้ Ollama API
echo.
echo 2️⃣ ใช้ Transformers:
echo    - pip install transformers torch
echo    - ใช้ HuggingFace models
echo.
echo 3️⃣ ใช้ WSL2:
echo    - wsl --install
echo    - ติดตั้งใน Linux environment
echo.
echo 4️⃣ ใช้ Docker:
echo    - docker run -p 8501:8501 [llama-image]
echo.

set /p choice="เลือกทางเลือก (1-4) หรือ Enter เพื่อออก: "

if "%choice%"=="1" (
    echo 🦙 เปิดหน้าดาวน์โหลด Ollama...
    start https://ollama.com/download
) else if "%choice%"=="2" (
    echo 🤗 ติดตั้ง Transformers...
    call "%~dp0install_alternative_llm.bat"
) else if "%choice%"=="3" (
    echo 🐧 ติดตั้ง WSL2...
    echo สำหรับ WSL2 กรุณารัน: wsl --install
) else if "%choice%"=="4" (
    echo 🐳 สำหรับ Docker ดูคำแนะนำใน documentation
)

goto :end

:manual_setup
echo.
echo 🛠️ การตั้งค่าแบบ Manual
echo ====================
echo.
echo 📋 ขั้นตอนที่ต้องทำ:
echo.
echo 1. เปิด Visual Studio Installer
echo 2. คลิก "Modify" บน Build Tools 2022
echo 3. เลือก "C++ build tools" workload
echo 4. ตรวจสอบว่ามี components เหล่านี้:
echo    ✅ MSVC v143 - VS 2022 C++ x64/x86 build tools
echo    ✅ Windows 11 SDK (10.0.22000.0)
echo    ✅ CMake tools for Visual Studio
echo 5. คลิก "Modify" และรอการติดตั้ง
echo 6. รีสตาร์ท Command Prompt
echo 7. รันสคริปต์นี้อีกครั้ง
echo.

echo 🔄 เปิด Visual Studio Installer...
start ms-settings:developers

echo.
echo ⏰ หลังจากติดตั้งเสร็จแล้ว ให้รีสตาร์ท Command Prompt
echo    แล้วรันสคริปต์นี้อีกครั้ง
echo.

:end
pause
exit /b 0
