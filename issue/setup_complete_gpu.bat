@echo off
chcp 65001 >nul

echo 🚀 Setup llama-cpp-python with GPU support for Windows
echo =================================================================

REM Check if in project directory
cd /d "%~dp0.."
if not exist "rag_chatbot.py" (
    echo ❌ File rag_chatbot.py not found
    echo    Please cd into the LLM-RAG directory first
    pause
    exit /b 1
)

echo 🔍 Checking Prerequisites...

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python not found
    echo    Please install Python 3.8+ from https://python.org
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%v in ('python --version 2^>^&1') do echo ✅ Python %%v
)

REM Check Git
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git not found
    echo    Please install Git from https://git-scm.com
    pause
    exit /b 1
) else (
    for /f "tokens=3" %%v in ('git --version 2^>^&1') do echo ✅ Git %%v
)

REM Check NVIDIA GPU
nvidia-smi >nul 2>&1
if errorlevel 1 (
    echo ⚠️ NVIDIA GPU or driver not found
    echo    GPU installation may not work properly
    set GPU_AVAILABLE=false
) else (
    echo ✅ NVIDIA GPU found
    nvidia-smi | findstr "CUDA Version"
    set GPU_AVAILABLE=true
)

REM User choice for installation type
echo:
echo 🎯 Select Installation Type:
echo =========================
echo 1. GPU Installation (Recommended if you have NVIDIA GPU)
echo    - Faster inference (25-35+ tokens/sec)
echo    - Requires CUDA-compatible GPU
echo    - Download size: ~447MB
echo:
echo 2. CPU Installation (Compatible with all systems)
echo    - Slower inference (8-12 tokens/sec)
echo    - Works on any computer
echo    - Download size: ~50MB
echo:

if "%GPU_AVAILABLE%"=="true" (
    echo 💡 Recommendation: GPU installation (Option 1)
) else (
    echo 💡 Recommendation: CPU installation (Option 2)
)

echo:
set /p INSTALL_CHOICE="Enter your choice (1 for GPU, 2 for CPU): "

if "%INSTALL_CHOICE%"=="1" (
    echo 🚀 You selected: GPU Installation
    set GPU_SUPPORT=true
) else (
    if "%INSTALL_CHOICE%"=="2" (
        echo 💻 You selected: CPU Installation
        set GPU_SUPPORT=false
    ) else (
        echo ❌ Invalid choice. Defaulting to CPU installation.
        set GPU_SUPPORT=false
    )
)

REM Check Virtual Environment
if not exist "llm_rag_env" (
    echo 📦 Creating Python virtual environment...
    python -m venv llm_rag_env
    if errorlevel 1 (
        echo ❌ Cannot create virtual environment
        pause
        exit /b 1
    )
) else (
    echo ✅ Virtual environment found
)

echo 🔄 Activating virtual environment...
call llm_rag_env\Scripts\activate.bat

REM Upgrade pip
echo 📦 Upgrading pip...
python -m pip install --upgrade pip

echo 📦 Installing basic dependencies...
pip install wheel setuptools

REM Install llama-cpp-python
echo:
echo 🦙 Installing llama-cpp-python...
echo 🗑️ Removing old version...
pip uninstall llama-cpp-python -y >nul 2>&1

if "%GPU_SUPPORT%"=="true" (
    echo:
    echo 🚀 Installing GPU version with CUDA support...
    echo ⚠️ Note: This may take 5-15 minutes and requires ~447MB download
    
    if "%GPU_AVAILABLE%"=="false" (
        echo ⚠️ Warning: No NVIDIA GPU detected. Installation may fail.
        echo    You can still proceed, but consider using CPU version instead.
        echo:
        set /p CONTINUE="Continue with GPU installation? (y/n): "
        if /i "%CONTINUE%"=="n" (
            echo 💻 Switching to CPU installation...
            set GPU_SUPPORT=false
            goto cpu_install
        )
    )
    
    echo 📥 Downloading GPU-optimized version for CUDA 12.1...
    pip install https://github.com/abetlen/llama-cpp-python/releases/download/v0.2.90-cu121/llama_cpp_python-0.2.90-cp311-cp311-win_amd64.whl --force-reinstall --no-deps
    
    if errorlevel 1 (
        echo:
        echo ❌ GPU installation failed!
        echo 💡 This could be due to:
        echo    - Network connection issues
        echo    - Incompatible CUDA version
        echo    - Missing Visual Studio Build Tools
        echo:
        set /p FALLBACK="Try CPU installation instead? (y/n): "
        if /i "%FALLBACK%"=="y" (
            echo 💻 Fallback to CPU version...
            goto cpu_install
        ) else (
            goto installation_failed
        )
    ) else (
        echo ✅ GPU installation successful!
        goto test_installation
    )
) else (
    goto cpu_install
)

:cpu_install
echo:
echo 💻 Installing CPU-only version...
echo 📥 Downloading and compiling (this may take a few minutes)...
pip install llama-cpp-python --no-cache-dir

if errorlevel 1 (
    echo ❌ CPU installation failed
    goto installation_failed
) else (
    echo ✅ CPU installation successful!
    set GPU_SUPPORT=false
)

:test_installation
REM Test installation
echo 🧪 Testing installation...
python -c "import llama_cpp; print(f'✅ llama-cpp-python version: {llama_cpp.__version__}')" 2>nul
if errorlevel 1 (
    echo ❌ Test failed - cannot import llama_cpp
    goto installation_failed
)

echo ✅ llama-cpp-python ready to use

REM Install other packages
echo 📦 Installing other packages...
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers

echo:
echo 🎉 Installation completed!
echo ===================
echo:
echo 📋 Next steps:
echo 1. Run application: streamlit run rag_chatbot.py
echo 2. Open browser to: http://localhost:8501
echo 3. Click "Create chatbot" to load the model
echo:

echo 📊 Your installation configuration:
if "%GPU_SUPPORT%"=="true" (
    echo    ✅ Type: GPU-accelerated installation
    echo    🚀 Expected performance: 25-35+ tokens/sec
    echo    💾 VRAM usage: ~2-3GB
    echo    💡 Look for "offloaded layers to GPU" in logs
) else (
    echo    ✅ Type: CPU-only installation  
    echo    💻 Expected performance: 8-12 tokens/sec
    echo    💾 RAM usage: ~3-4GB
    echo    💡 All processing will use CPU
)

echo:
pause
exit /b 0

:installation_failed
echo:
echo ❌ Installation failed
echo ==================
echo:
echo 🔧 Troubleshooting:
echo 1. Check network connection and retry
echo 2. Run: pip install llama-cpp-python --no-cache-dir
echo 3. See troubleshooting guide: .\issue\LLAMA_CPP_PYTHON_TROUBLESHOOTING.md
echo:

pause
exit /b 1
