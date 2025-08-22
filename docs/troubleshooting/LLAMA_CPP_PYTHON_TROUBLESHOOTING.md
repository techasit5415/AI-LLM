# แก้ไขปัญหา llama-cpp-python บน Windows
## คู่มือแก้ปัญหาและติดตั้งแบบละเอียด

### 🔍 ปัญหาที่พบบ่อย

#### 1. ImportError: Could not import llama-cpp-python library
```
ImportError: Could not import llama-cpp-python library. 
Please install the llama-cpp-python library to use this embedding model: 
pip install llama-cpp-python
```

#### 2. Build Error: CMAKE_C_COMPILER not set
```
CMake Error: CMAKE_C_COMPILER not set, after EnableLanguage
CMake Error: CMAKE_CXX_COMPILER not set, after EnableLanguage
```

#### 3. FAISS Compatibility Error
```
TypeError: FAISS.__init__() got an unexpected keyword argument 'allow_dangerous_deserialization'
```

---

## 🛠️ สาเหตุและวิธีแก้ไข

### สาเหตุหลัก:
1. **ขาด Visual Studio Build Tools** - จำเป็นสำหรับ compile C++ code
2. **ขาด C++ Compiler** - llama-cpp-python ต้องการ MSVC compiler
3. **Version ไม่เข้ากัน** - langchain และ faiss version conflicts
4. **CUDA Setup ไม่ถูกต้อง** - สำหรับ GPU support

---

## 🚀 วิธีแก้ปัญหาแบบ Step-by-Step

### Method 1: ติดตั้ง Visual Studio Community (แนะนำ) 🌟

#### ขั้นตอนที่ 1: ติดตั้ง Visual Studio Community
```cmd
REM ติดตั้งผ่าน winget
winget install Microsoft.VisualStudio.2022.Community

REM หรือดาวน์โหลดจาก
REM https://visualstudio.microsoft.com/vs/community/
```

#### ขั้นตอนที่ 2: เลือก Workloads
เมื่อติดตั้ง Visual Studio ให้เลือก:
- ✅ **Desktop development with C++**
- ✅ **MSVC v143 - VS 2022 C++ x64/x86 build tools**
- ✅ **Windows 10/11 SDK**
- ✅ **CMake tools for Visual Studio**

#### ขั้นตอนที่ 3: รีสตาร์ท Command Prompt
```cmd
REM ปิด command prompt เก่า
REM เปิดใหม่เพื่อให้ environment variables update
```

#### ขั้นตอนที่ 4: ติดตั้ง llama-cpp-python
```cmd
REM เปิดใช้งาน virtual environment
llm_rag_env\Scripts\activate.bat

REM ⚠️ สำคัญ: ตั้งค่า VS environment ก่อน
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

REM สำหรับ CPU-only (แนะนำ)
pip install llama-cpp-python==0.2.90 --no-cache-dir --force-reinstall

REM หรือสำหรับ GPU support
set CMAKE_ARGS=-DLLAMA_CUBLAS=on
set FORCE_CMAKE=1
pip install llama-cpp-python==0.2.90 --no-cache-dir --force-reinstall

REM ทดสอบ
python -c "from llama_cpp import Llama; print('✅ Success!')"
```

#### 🚨 หากยังติดตั้งไม่ได้หลังจากติดตั้ง Build Tools:
```cmd
REM รันสคริปต์แก้ไขปัญหา
.\issue\fix_buildtools_installation.bat
```

---

### Method 2: ใช้ Pre-compiled Wheels 🔧

#### สำหรับ CPU-only:
```cmd
pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cpu
```

#### สำหรับ CUDA 12.1:
```cmd
pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cu121
```

#### สำหรับ CUDA 11.8:
```cmd
pip install llama-cpp-python --index-url https://abetlen.github.io/llama-cpp-python/whl/cu118
```

---

### Method 3: ใช้ Alternative Package 📦

#### Option A: ใช้ transformers แทน
```cmd
pip install transformers torch torchvision torchaudio
```

จากนั้นแก้ไขโค้ดใน `pages/backend/rag_functions.py`:
```python
# แทนที่ LlamaCpp ด้วย HuggingFacePipeline
from langchain.llms import HuggingFacePipeline
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline

# สร้าง pipeline
model_name = "microsoft/DialoGPT-medium"  # หรือ model อื่นที่เหมาะสม
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)
pipe = pipeline("text-generation", model=model, tokenizer=tokenizer)
llm = HuggingFacePipeline(pipeline=pipe)
```

#### Option B: ใช้ Online API
```cmd
pip install openai langchain-openai
```

แก้ไขโค้ดให้ใช้ OpenAI API:
```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    model="gpt-3.5-turbo",
    api_key="your_api_key_here"
)
```

---

### Method 4: ใช้ WSL2 (สำหรับ Advanced Users) 🐧

#### ติดตั้ง WSL2:
```cmd
wsl --install Ubuntu
```

#### ใน Ubuntu:
```bash
# อัพเดต system
sudo apt update && sudo apt upgrade -y

# ติดตั้ง dependencies
sudo apt install -y python3-pip python3-venv build-essential cmake

# สร้าง virtual environment
python3 -m venv llm_rag_env
source llm_rag_env/bin/activate

# ติดตั้ง llama-cpp-python
CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python==0.2.90

# ติดตั้ง packages อื่นๆ
pip install streamlit langchain langchain-community faiss-cpu sentence-transformers
```

---

## 🧪 การทดสอบและ Troubleshooting

### ทดสอบ llama-cpp-python:
```cmd
python scripts/testing/benchmark_llama_cpp.py
# หรือ
python -c "from llama_cpp import Llama; print('✅ llama-cpp-python ทำงานได้')"
```

### ทดสอบ CUDA support:
```cmd
python scripts/testing/check_llama_cuda.py
# หรือ
python scripts/testing/validate_gpu_setup.py
```

### ทดสอบ GPU detection:
```cmd
python scripts/testing/test_gpu.py
```

### รันทุก tests:
```cmd
# Windows
.\scripts\testing\run_test_scripts.bat

# Linux/macOS  
./scripts/testing/run_test_scripts.sh
```

### ตรวจสอบ GPU usage:
```cmd
REM รัน nvidia-smi ขณะที่ใช้งาน LLM
nvidia-smi

REM หาข้อความนี้ใน log:
REM "assigned to device CUDA0"
```

---

## 📊 Performance Comparison

| Method | Speed (tokens/sec) | Setup Difficulty | GPU Support |
|--------|-------------------|------------------|-------------|
| Visual Studio + CUDA | 3500-4000+ | Hard | ✅ Yes |
| Pre-compiled CUDA wheel | 3000-3500 | Medium | ✅ Yes |
| Pre-compiled CPU wheel | 2000-2500 | Easy | ❌ No |
| Transformers | 1000-1500 | Easy | ⚠️ Limited |
| WSL2 + CUDA | 3500-4000+ | Hard | ✅ Yes |

---

## 🔧 วิธีแก้ปัญหาเฉพาะ

### ปัญหา: "No module named '_ctypes'"
```cmd
REM ติดตั้ง Visual C++ Redistributable
winget install Microsoft.VCRedist.2015+.x64
```

### ปัญหา: "CUDA runtime error"
```cmd
REM ตรวจสอบ CUDA version
nvcc --version
nvidia-smi

REM อัพเดต CUDA driver
REM ดาวน์โหลดจาก https://developer.nvidia.com/cuda-downloads
```

### ปัญหา: "Out of memory"
```python
# ลด model size หรือ context length
llm = LlamaCpp(
    model_path=llm_model,
    temperature=temperature,
    max_tokens=max_length,
    n_ctx=2048,  # ลดจาก 4096
    n_gpu_layers=20,  # ลดจาก -1 (all layers)
    n_batch=256,  # ลดจาก 512
)
```

---

## 📋 Checklist การติดตั้ง

### Pre-requirements:
- [ ] Windows 10/11 (64-bit)
- [ ] Python 3.8+ 
- [ ] NVIDIA GPU + Driver (สำหรับ GPU support)
- [ ] 16GB+ RAM
- [ ] 50GB+ disk space

### Installation Steps:
- [ ] ติดตั้ง Visual Studio Community/Build Tools
- [ ] เลือก C++ workload
- [ ] รีสตาร์ท command prompt
- [ ] สร้าง virtual environment
- [ ] ติดตั้ง llama-cpp-python
- [ ] ทดสอบ import
- [ ] ติดตั้ง dependencies อื่นๆ
- [ ] รันและทดสอบ application

### Verification:
- [ ] `python -c "from llama_cpp import Llama"` ไม่มี error
- [ ] `nvidia-smi` แสดง GPU usage เมื่อรัน
- [ ] LLM speed > 3000 tokens/sec (GPU) หรือ > 2000 tokens/sec (CPU)
- [ ] Application รันได้โดยไม่มี error

---

## 📞 Support และแหล่งข้อมูลเพิ่มเติม

### Official Documentation:
- [llama-cpp-python GitHub](https://github.com/abetlen/llama-cpp-python)
- [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022)
- [NVIDIA CUDA Toolkit](https://developer.nvidia.com/cuda-downloads)

### Community Resources:
- [r/LocalLLaMA](https://reddit.com/r/LocalLLaMA) - Reddit community
- [LangChain Documentation](https://python.langchain.com/docs/get_started/introduction)

### Alternative Projects:
- [Ollama](https://ollama.ai/) - Easy LLM management
- [LM Studio](https://lmstudio.ai/) - GUI for local LLMs
- [Text Generation WebUI](https://github.com/oobabooga/text-generation-webui)

---

## 🎯 สรุป

การติดตั้ง llama-cpp-python บน Windows อาจซับซ้อน แต่เมื่อติดตั้งสำเร็จแล้วจะได้ performance ที่ดีที่สุด

**แนะนำ:** เริ่มจาก **Method 1** (Visual Studio Community) เพราะจะได้ GPU support เต็มรูปแบบ หากติดตั้งไม่สำเร็จให้ลอง **Method 2** (Pre-compiled wheels) หรือ **Method 4** (WSL2)

สำหรับ production use แนะนำให้ใช้ **Method 4** (WSL2) เพราะ stable และ performance ดีที่สุด
