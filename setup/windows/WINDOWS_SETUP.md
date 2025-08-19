# Windows Setup Guide for LLM-RAG Chatbot
## ระบบ RAG Chatbot ที่ใช้ Local LLM พร้อม GPU acceleration บน Windows

### ข้อกำหนดระบบ
- Windows 10/11 (64-bit)
- NVIDIA GPU (แนะนำ 8GB+ VRAM)
- Python 3.8+ 
- 16GB+ RAM
- 50GB+ พื้นที่ว่าง

## 🚀 การติดตั้งแบบอัตโนมัติ (แนะนำ) 

### วิธีที่ 1: ใช้สคริปต์ติดตั้งครบชุด
```cmd
REM ติดตั้งทุกอย่างด้วยสคริปต์เดียว (รวมถึง Visual Studio)
install_complete_detailed.bat
```

### วิธีที่ 2: ติดตั้งแยกขั้นตอน
```cmd
REM 1. ตรวจสอบระบบ
auto_setup_windows.bat

REM 2. ติดตั้ง Python environment
setup_python_env_windows.bat

REM 3. ดาวน์โหลด models
download_models_windows.bat

REM 4. รัน application
run_app_windows.bat
```

### วิธีที่ 3: Troubleshooting
```cmd
REM หากมีปัญหา ใช้สคริปต์วินิจฉัย
diagnose_llama_cpp.bat
```

---

#### 1. ติดตั้ง NVIDIA CUDA Toolkit
```cmd
REM ดาวน์โหลดและติดตั้ง CUDA Toolkit 12.x จาก:
REM https://developer.nvidia.com/cuda-downloads

REM ตรวจสอบการติดตั้ง
nvidia-smi
nvcc --version
```

#### 2. ติดตั้ง Python
```cmd
REM ดาวน์โหลด Python 3.11 จาก python.org
REM ตรวจสอบว่าเลือก "Add Python to PATH" เวลาติดตั้ง

python --version
pip --version
```

#### 3. ติดตั้ง Git และ Build Tools
```cmd
REM ดาวน์โหลดและติดตั้ง:
REM - Git for Windows: https://git-scm.com/download/win
REM - Visual Studio Build Tools: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022

git --version
```

#### 4. สร้าง Python Virtual Environment
```cmd
REM สร้าง virtual environment
python -m venv llm_rag_env

REM เปิดใช้งาน (Windows CMD)
llm_rag_env\Scripts\activate.bat

REM หรือ PowerShell
llm_rag_env\Scripts\Activate.ps1

REM อัพเกรด pip
python -m pip install --upgrade pip
```

#### 5. ติดตั้ง Python Packages
```cmd
REM เปิดใช้งาน virtual environment ก่อน
llm_rag_env\Scripts\activate.bat

REM ติดตั้งจาก requirements.txt
pip install -r requirements.txt

REM ติดตั้ง PyTorch สำหรับ CUDA
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

REM ติดตั้ง llama-cpp-python พร้อม CUDA support
set CMAKE_ARGS=-DLLAMA_CUBLAS=on
pip install llama-cpp-python==0.2.90 --no-cache-dir
```

#### 6. ตั้งค่า Environment Variables (Optional)
```cmd
REM เพิ่มใน System Environment Variables:
set CUDA_VISIBLE_DEVICES=0
set CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1
```

#### 7. ดาวน์โหลด LLM Model
```cmd
REM สร้างโฟลเดอร์สำหรับ models
mkdir C:\AI\llm\Llama-3.2-3B-Instruct-GGUF
cd C:\AI\llm\Llama-3.2-3B-Instruct-GGUF

REM ดาวน์โหลด model (ใช้ browser หรือ wget for Windows)
curl -L -o Llama-3.2-3B-Instruct-Q5_K_M.gguf https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf
```

#### 8. เตรียม Embedding Model (Optional)
```cmd
mkdir C:\AI\embedding-models
cd C:\AI\embedding-models
git clone https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2
```

#### 9. แก้ไข Path ในโค้ด
แก้ไขไฟล์ `rag_chatbot.py` บรรทัด 46:
```python
# เปลี่ยนจาก Linux path
llm_model = r"C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf"

# และแก้ไข embedding path ด้วย (บรรทัด 20)
local_embed_path = r"C:\AI\embedding-models\all-MiniLM-L6-v2"
```

#### 10. ทดสอบการติดตั้ง
```cmd
REM เปิดใช้งาน virtual environment
llm_rag_env\Scripts\activate.bat

REM เข้าไปใน project directory
cd LLM-RAG

REM รัน Streamlit
streamlit run rag_chatbot.py
```

### การแก้ไขปัญหาทั่วไป

#### หาก llama-cpp-python ไม่รู้จัก CUDA:
```cmd
pip uninstall llama-cpp-python
set CMAKE_ARGS=-DLLAMA_CUBLAS=on
pip install llama-cpp-python --no-cache-dir --force-reinstall
```

#### หากไม่มี Visual Studio Build Tools:
```cmd
REM ติดตั้ง Visual Studio Build Tools 2022
REM หรือใช้ conda แทน pip:
conda install -c conda-forge llama-cpp-python
```

#### หาก CUDA ไม่ทำงาน:
```cmd
REM ตรวจสอบ CUDA path
echo %CUDA_PATH%
echo %PATH%

REM เพิ่ม CUDA ใน PATH หากจำเป็น
set PATH=%CUDA_PATH%\bin;%PATH%
```

#### หากมีปัญหา PowerShell Execution Policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Windows-specific Tips:

#### ใช้ Conda แทน pip (แนะนำ):
```cmd
REM ติดตั้ง Miniconda
REM https://docs.conda.io/en/latest/miniconda.html

conda create -n llm_rag python=3.11
conda activate llm_rag
conda install -c conda-forge streamlit langchain faiss-cpu sentence-transformers
pip install llama-cpp-python --no-cache-dir
```

#### ใช้ WSL2 (สำหรับ Advanced Users):
```bash
# ติดตั้ง WSL2 และ Ubuntu
# จากนั้นใช้ Linux setup scripts
wsl --install Ubuntu
# ใช้ auto_setup.sh ใน WSL
```

### Performance ที่คาดหวัง (Windows):
- **CPU:** ~2,500 tokens/second
- **GPU:** ~3,800+ tokens/second
- **Memory Usage:** ~4-6GB VRAM สำหรับ 3B model

---

## 📁 Model Paths สำหรับ Windows

### LLM Model:
```
Path: C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf
Size: ~2.16 GB
URL: https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf
```

### Embedding Model (Optional):
```
Path: C:\AI\embedding-models\all-MiniLM-L6-v2
Size: ~90 MB
URL: https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2
```
