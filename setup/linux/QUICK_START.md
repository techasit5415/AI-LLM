# Quick Start Guide
# คู่มือติดตั้งด่วนสำหรับเครื่องใหม่

## ขั้นตอนติดตั้งแบบละเอียด (Full Setup)

### 1. ติดตั้ง System Dependencies
```bash
./auto_setup.sh
source ~/.bashrc
```

### 2. ติดตั้ง Python Environment  
```bash
cd LLM-RAG
./setup_python_env.sh
```

### 3. ดาวน์โหลด Models
```bash
./download_models.sh
```

### 4. ปรับ Path ในโค้ด
แก้ไขไฟล์ `rag_chatbot.py` บรรทัด 46:
```python
llm_model = "/home/YOUR_USERNAME/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf"
```

### 5. รัน Application
```bash
source llm_rag_env/bin/activate
streamlit run rag_chatbot.py
```

---

## ขั้นตอนติดตั้งแบบด่วน (Quick Setup)

### เครื่องที่มี CUDA แล้ว:
```bash
# 1. ติดตั้ง dependencies
sudo apt update
sudo apt install -y python3-venv python3-pip build-essential cmake

# 2. สร้าง environment
python3 -m venv llm_rag_env
source llm_rag_env/bin/activate

# 3. ติดตั้ง packages
pip install -r requirements.txt
CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python==0.2.90

# 4. ดาวน์โหลด model
./download_models.sh

# 5. รัน
streamlit run rag_chatbot.py
```

---

## Files ที่ต้อง Copy ไปเครื่องใหม่

### Required Files:
```
LLM-RAG/
├── rag_chatbot.py              # Main application
├── pages/backend/rag_functions.py  # Backend functions
├── requirements.txt            # Python dependencies
├── vector store/              # Pre-built vector databases
│   ├── naruto/
│   ├── snake/ 
│   └── naruto_snake/
└── data sources/              # Source documents
    ├── wikipedia_naruto.txt
    └── wikipedia_snake.txt
```

### Setup Scripts:
```
├── auto_setup.sh              # ติดตั้ง system dependencies
├── setup_python_env.sh        # ติดตั้ง Python environment
├── download_models.sh          # ดาวน์โหลด models
├── install_system_deps.sh      # Manual system install
├── SETUP_GUIDE.md             # คู่มือเต็ม
└── QUICK_START.md             # ไฟล์นี้
```

---

## Troubleshooting

### ปัญหา CUDA:
```bash
# ตรวจสอบ
nvidia-smi
nvcc --version

# แก้ไข environment
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
```

### ปัญหา llama-cpp-python:
```bash
pip uninstall llama-cpp-python
CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python --no-cache-dir
```

### ปัญหา Streamlit:
```bash
pip install --upgrade streamlit
```

---

## Performance Check

### ตรวจสอบว่าใช้ GPU:
- ดูใน log ว่ามี "assigned to device CUDA0" 
- ความเร็ว > 3000 tokens/second = ใช้ GPU
- ความเร็ว ~2700 tokens/second = ใช้ CPU

### Expected Performance:
- **RTX 4060:** ~4000 tokens/second
- **RTX 3060:** ~3500 tokens/second  
- **GTX 1660:** ~3000 tokens/second
- **CPU only:** ~2700 tokens/second
