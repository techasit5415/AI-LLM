# Windows Setup - Quick Start Guide
## คู่มือติดตั้งด่วนสำหรับ Windows

### ข้อกำหนดเบื้องต้น
- Windows 10/11 (64-bit)
- NVIDIA GPU พร้อม driver
- Python 3.8+
- Git for Windows

---

## ขั้นตอนติดตั้งแบบอัตโนมัติ

### 1. ติดตั้ง Prerequisites
```cmd
REM ติดตั้งสิ่งเหล่านี้ก่อน:
REM 1. Python จาก python.org (เลือก "Add to PATH")
REM 2. Git for Windows จาก git-scm.com  
REM 3. NVIDIA CUDA Toolkit จาก developer.nvidia.com
REM 4. Visual Studio Build Tools (optional แต่แนะนำ)
```

### 2. รัน Setup Scripts
```cmd
REM Copy โฟลเดอร์ LLM-RAG มาในเครื่อง Windows
cd LLM-RAG

REM 1. ตรวจสอบระบบ
auto_setup_windows.bat

REM 2. ติดตั้ง Python environment
setup_python_env_windows.bat

REM 3. ดาวน์โหลด models
download_models_windows.bat

REM 4. รัน application
run_app_windows.bat
```

---

## ขั้นตอนติดตั้งแบบ Manual

### 1. สร้าง Virtual Environment
```cmd
python -m venv llm_rag_env
llm_rag_env\Scripts\activate.bat
python -m pip install --upgrade pip
```

### 2. ติดตั้ง Packages
```cmd
REM ติดตั้ง PyTorch สำหรับ CUDA
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

REM ติดตั้ง packages อื่นๆ
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers
pip install pypdf python-docx tiktoken numpy pandas requests beautifulsoup4 lxml Pillow python-dotenv

REM ติดตั้ง llama-cpp-python พร้อม CUDA
set CMAKE_ARGS=-DLLAMA_CUBLAS=on
pip install llama-cpp-python==0.2.90 --no-cache-dir
```

### 3. ดาวน์โหลด Models
```cmd
REM สร้างโฟลเดอร์
mkdir %USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF
cd %USERPROFILE%\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF

REM ดาวน์โหลด LLM model
curl -L -o Llama-3.2-3B-Instruct-Q5_K_M.gguf https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf
```

### 4. แก้ไข Path ในโค้ด
แก้ไขไฟล์ `rag_chatbot.py`:

**บรรทัด 46:**
```python
# จาก
llm_model = "/home/techasit/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf"

# เปลี่ยนเป็น
llm_model = r"C:\Users\{USERNAME}\Documents\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf"
```

**บรรทัด 20:**
```python
# จาก  
local_embed_path = "/home/techasit/Documents/AI/embedding-models/all-MiniLM-L6-v2"

# เปลี่ยนเป็น
local_embed_path = r"C:\Users\{USERNAME}\Documents\AI\embedding-models\all-MiniLM-L6-v2"
```

### 5. รัน Application
```cmd
llm_rag_env\Scripts\activate.bat
streamlit run rag_chatbot.py
```

---

## Troubleshooting Windows

### ปัญหา CUDA ไม่ทำงาน:
```cmd
REM ตรวจสอบ CUDA
nvidia-smi
nvcc --version

REM ตั้งค่า environment variables
set CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1
set PATH=%CUDA_PATH%\bin;%PATH%
```

### ปัญหา llama-cpp-python:
```cmd
REM ลบและติดตั้งใหม่
pip uninstall llama-cpp-python
set CMAKE_ARGS=-DLLAMA_CUBLAS=on
pip install llama-cpp-python --no-cache-dir --force-reinstall
```

### ปัญหา PowerShell Execution Policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### ปัญหา Build Tools:
```cmd
REM ติดตั้ง Visual Studio Build Tools 2022
REM หรือใช้ conda:
conda install -c conda-forge llama-cpp-python
```

### ปัญหาดาวน์โหลด Models:
```cmd
REM ถ้า curl ไม่ทำงาน ใช้ PowerShell:
powershell -Command "Invoke-WebRequest -Uri 'https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf' -OutFile 'Llama-3.2-3B-Instruct-Q5_K_M.gguf'"

REM หรือดาวน์โหลดผ่าน browser แล้ว copy มาใส่ folder
```

---

## Files ที่ต้อง Copy ไปเครื่อง Windows

### Core Files:
```
LLM-RAG\
├── rag_chatbot.py              # Main app (ต้องแก้ path)
├── pages\backend\rag_functions.py  # Backend functions  
├── requirements.txt            # Python dependencies
├── vector store\              # Pre-built vector databases
│   ├── naruto\
│   ├── snake\
│   └── naruto_snake\
└── data sources\              # Source documents
    ├── wikipedia_naruto.txt
    └── wikipedia_snake.txt
```

### Windows Setup Scripts:
```
├── auto_setup_windows.bat          # ตรวจสอบระบบ
├── setup_python_env_windows.bat    # ติดตั้ง Python env
├── download_models_windows.bat     # ดาวน์โหลด models
├── run_app_windows.bat             # รัน application
├── WINDOWS_SETUP.md                # คู่มือเต็ม
└── WINDOWS_QUICK_START.md          # ไฟล์นี้
```

---

## Expected Performance (Windows)
- **RTX 4060:** ~3,800 tokens/second  
- **RTX 3060:** ~3,300 tokens/second
- **GTX 1660:** ~2,800 tokens/second
- **CPU only:** ~2,500 tokens/second

---

## Tips สำหรับ Windows

1. **ใช้ Command Prompt** แทน PowerShell ถ้ามีปัญหา
2. **ติดตั้ง Conda** ถ้า pip มีปัญหา
3. **ตรวจสอบ Antivirus** ว่าไม่ block Python scripts
4. **ใช้ WSL2** สำหรับ advanced users ที่ต้องการ Linux environment
