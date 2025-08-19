# LLM-RAG Chatbot Setup Guide
## ระบบ RAG Chatbot ที่ใช้ Local LLM พร้อม GPU acceleration

### ข้อกำหนดระบบ
- Ubuntu/Debian Linux
- NVIDIA GPU (แนะนำ 8GB+ VRAM)
- Python 3.8+
- 16GB+ RAM
- 50GB+ พื้นที่ว่าง

### การติดตั้งแบบขั้นตอน

#### 1. ติดตั้ง System Dependencies
```bash
# ให้สิทธิ์และรัน script
chmod +x install_system_deps.sh
./install_system_deps.sh

# หรือติดตั้งทีละคำสั่ง:
sudo apt update
sudo apt install -y nvidia-cuda-toolkit build-essential cmake git wget curl
sudo apt install -y python3-dev python3-pip python3-venv
sudo apt install -y libblas-dev liblapack-dev libopenblas-dev gfortran
sudo apt install -y libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev libgomp1
sudo apt install -y poppler-utils ffmpeg libsndfile1
sudo apt install -y htop tree unzip
```

#### 2. ตรวจสอบ NVIDIA Driver และ CUDA
```bash
# ตรวจสอบ GPU
nvidia-smi

# ตรวจสอบ CUDA
nvcc --version

# หากยังไม่มี NVIDIA Driver
sudo apt install -y nvidia-driver-535
sudo reboot
```

#### 3. สร้าง Python Virtual Environment
```bash
# สร้าง virtual environment
python3 -m venv llm_rag_env

# เปิดใช้งาน
source llm_rag_env/bin/activate

# อัพเกรด pip
pip install --upgrade pip
```

#### 4. ติดตั้ง Python Packages
```bash
# ติดตั้งจาก requirements.txt
pip install -r requirements.txt

# หรือติดตั้งทีละ package หากมีปัญหา:
pip install streamlit==1.29.0
pip install langchain==0.1.0 langchain-community==0.0.10
pip install faiss-cpu==1.7.4
pip install sentence-transformers==2.2.2
pip install pypdf==3.17.4
pip install numpy pandas torch torchvision torchaudio
pip install requests beautifulsoup4 lxml Pillow python-dotenv

# ติดตั้ง llama-cpp-python พร้อม CUDA support
CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python==0.2.90
```

#### 5. เตรียม Environment Variables
```bash
# เพิ่มใน ~/.bashrc
echo 'export CUDA_VISIBLE_DEVICES=0' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### 6. ดาวน์โหลด LLM Model
```bash
# สร้างโฟลเดอร์สำหรับ models
mkdir -p /home/$(whoami)/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF

# ดาวน์โหลด Llama 3.2 3B Instruct GGUF
cd /home/$(whoami)/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF
wget https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf

# LLM path: /home/$(whoami)/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf
```

#### 7. เตรียม Embedding Model (Optional)
```bash
# ดาวน์โหลด embedding model สำหรับใช้ offline
mkdir -p /home/$(whoami)/Documents/AI/embedding-models
cd /home/$(whoami)/Documents/AI/embedding-models
git clone https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2

# Embedding path: /home/$(whoami)/Documents/AI/embedding-models/all-MiniLM-L6-v2
```

#### 8. Setup Project
```bash
# Clone หรือ copy โปรเจค LLM-RAG
git clone <repository-url> LLM-RAG
cd LLM-RAG

# แก้ไข path ในไฟล์ rag_chatbot.py (บรรทัด 46)
# เปลี่ยนเป็น path ที่ถูกต้องในเครื่องใหม่
```

#### 9. ทดสอบการติดตั้ง
```bash
# เปิดใช้งาน virtual environment
source llm_rag_env/bin/activate

# เข้าไปใน project directory
cd LLM-RAG

# รัน Streamlit
streamlit run rag_chatbot.py
```

### การแก้ไขปัญหาทั่วไป

#### หาก llama-cpp-python ไม่รู้จัก CUDA:
```bash
pip uninstall llama-cpp-python
CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python --no-cache-dir
```

#### หาก CUDA ไม่ทำงาน:
```bash
# ตรวจสอบ CUDA path
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
```

#### หากมีปัญหา torch:
```bash
pip uninstall torch torchvision torchaudio
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

### Structure ของ Project ที่ต้องมี:
```
LLM-RAG/
├── rag_chatbot.py
├── requirements.txt
├── install_system_deps.sh
├── README.md (ไฟล์นี้)
├── pages/
│   └── backend/
│       └── rag_functions.py
├── vector store/
│   ├── naruto/
│   ├── snake/
│   └── naruto_snake/
└── data sources/
    ├── wikipedia_naruto.txt
    └── wikipedia_snake.txt
```

### การใช้งาน:
1. เปิด browser ไปที่ `http://localhost:8501`
2. กด "Create chatbot" 
3. เลือก Vector Store ที่ต้องการ
4. เริ่มถามคำถาม!

### Performance ที่คาดหวัง:
- **CPU:** ~2,700 tokens/second
- **GPU:** ~4,000+ tokens/second
- **Memory Usage:** ~4-6GB VRAM สำหรับ 3B model

---

## 📁 Model Paths สำหรับ Linux

### LLM Model:
```
Path: ~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf
Full Path: /home/$(whoami)/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf
Size: ~2.16 GB
URL: https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf
```

### Embedding Model (Optional):
```
Path: ~/Documents/AI/embedding-models/all-MiniLM-L6-v2
Full Path: /home/$(whoami)/Documents/AI/embedding-models/all-MiniLM-L6-v2
Size: ~90 MB
URL: https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2
```
