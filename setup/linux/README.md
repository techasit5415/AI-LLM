# Linux Setup Scripts

## รันได้เลย - One Command Setup

### Quick Setup (แนะนำ):
```bash
sudo apt update && sudo apt install -y git git-lfs python3-venv python3-dev build-essential cmake
git clone https://github.com/techasit5415/AI-LLM.git
cd AI-LLM
chmod +x setup/linux/*.sh
./setup/linux/auto_setup.sh && ./setup/linux/setup_python_env.sh && ./setup/linux/download_models.sh
./setup/linux/run_app.sh
```

## Scripts รายตัว

### 1. `auto_setup.sh`
- ติดตั้ง system dependencies (CUDA, build tools, Git LFS)
- ติดตั้งแพ็คเกจที่จำเป็นทั้งหมด

### 2. `setup_python_env.sh` 
- สร้าง Python virtual environment
- ติดตั้ง Python packages ที่เข้ากันได้
- แก้ไข NumPy compatibility อัตโนมัติ
- ใช้ `GGML_CUDA` แทน `LLAMA_CUBLAS` (แก้ไขแล้ว)

### 3. `download_models.sh`
- ดาวน์โหลด LLM model (Llama 3.2 3B)
- ดาวน์โหลด embedding model ด้วย Git LFS
- ตรวจสอบไฟล์ที่ดาวน์โหลดสมบูรณ์

### 4. `run_app.sh`
- รัน Streamlit application
- ตรวจสอบ dependencies อัตโนมัติ
- เปิด browser ที่ localhost:8501

### 5. `fix_vector_store.sh` (Troubleshooting)
- แก้ไขปัญหา `KeyError: '__fields_set__'`
- ลบและสร้าง FAISS index ใหม่
- แก้ไข package compatibility

## การใช้งาน

### รันครั้งแรก:
```bash
./setup/linux/auto_setup.sh      # ติดตั้ง system
./setup/linux/setup_python_env.sh # ติดตั้ง Python
./setup/linux/download_models.sh  # ดาวน์โหลด models
./setup/linux/run_app.sh         # รัน app
```

### รันครั้งต่อไป:
```bash
./setup/linux/run_app.sh
```

### แก้ไขปัญหา:
```bash
./setup/linux/fix_vector_store.sh  # แก้ vector store
```

## Features ที่แก้ไขแล้ว

✅ **CUDA Support**: ใช้ `GGML_CUDA` แทน `LLAMA_CUBLAS`  
✅ **NumPy Compatibility**: แก้ไข version conflicts  
✅ **Git LFS**: ดาวน์โหลด embedding model สมบูรณ์  
✅ **Vector Store**: แก้ไขปัญหา `__fields_set__`  
✅ **Auto Path**: ไม่ต้องแก้ไข path manually  
✅ **One Command**: รันได้เลยด้วยคำสั่งเดียว  

## System Requirements

- Ubuntu/Debian Linux
- NVIDIA GPU (สำหรับ CUDA)
- Python 3.8+
- 8GB+ RAM
- 10GB+ Storage
