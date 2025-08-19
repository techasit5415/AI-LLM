# LLM-RAG Documentation Index
## ดัชนีเอกสารครบชุดสำหรับ LLM-RAG Chatbot

### 📚 เอกสารหลัก

#### 🏠 [README.md](../README.md)
เอกสารหลักของโปรเจค รวม:
- ภาพรวมระบบ
- โครงสร้างโปรเจคใหม่
- การติดตั้งแบบย่อ
- วิธีใช้งานพื้นฐาน
- Performance benchmarks (GPU: 25-35+ tokens/sec)

#### ⚡ [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
คู่มืออ้างอิงแบบด่วน:
- คำสั่งสำคัญ
- File paths และ structure
- Troubleshooting ด่วน

#### 🛠️ [setup/README.md](../setup/README.md)
คู่มือติดตั้งแบบครบถ้วน:
- โครงสร้างโฟลเดอร์ setup
- คำสั่งติดตั้งสำหรับ Linux และ Windows
- ตารางสรุป scripts ทั้งหมด

---

### 🖥️ Windows Documentation

#### 📖 [setup/windows/WINDOWS_SETUP.md](setup/windows/WINDOWS_SETUP.md)
คู่มือติดตั้งแบบละเอียดสำหรับ Windows:
- การติดตั้ง prerequisites ทั้งหมด
- ขั้นตอนติดตั้งทีละขั้นตอน
- การแก้ไขปัญหาทั่วไป
- คำแนะนำ performance tuning

#### ⚡ [setup/windows/WINDOWS_QUICK_START.md](setup/windows/WINDOWS_QUICK_START.md)
คู่มือติดตั้งแบบด่วนสำหรับ Windows:
- การติดตั้งแบบ manual
- ไฟล์ที่จำเป็นต้อง copy
- Troubleshooting แบบด่วน
- Tips สำหรับ Windows

---

### 🐧 Linux Documentation

#### 📖 [setup/linux/SETUP_GUIDE.md](setup/linux/SETUP_GUIDE.md)
คู่มือติดตั้งแบบละเอียดสำหรับ Linux:
- การติดตั้ง system dependencies
- การ setup CUDA environment
- ขั้นตอนติดตั้งครบถ้วน
- การแก้ไขปัญหา Linux specific

#### ⚡ [setup/linux/QUICK_START.md](setup/linux/QUICK_START.md)
คู่มือติดตั้งแบบด่วนสำหรับ Linux:
- การติดตั้งแบบ one-command
- ไฟล์ที่จำเป็น
- Performance check
- Model paths

---

### 🔧 Troubleshooting Documentation

#### 🚨 [troubleshooting/LLAMA_CPP_PYTHON_TROUBLESHOOTING.md](troubleshooting/LLAMA_CPP_PYTHON_TROUBLESHOOTING.md)
คู่มือแก้ปัญหา llama-cpp-python แบบละเอียด:
- ปัญหาที่พบบ่อยและสาเหตุ
- วิธีแก้ไขแบบ step-by-step (4 methods)
- การทดสอบและ verification
- Performance comparison (31.35 vs 11 tokens/sec)
- Alternative solutions

#### 🎯 [troubleshooting/GPU_SETUP_UPDATES.md](troubleshooting/GPU_SETUP_UPDATES.md)
สรุปการอัปเดต GPU setup script:
- วิธีการติดตั้งที่พิสูจน์แล้ว (direct wheel method)
- การปรับปรุง error handling
- Performance metrics ที่ถูกต้อง
- Validated outcomes

---

### 🧪 Testing & Validation Scripts

#### 📊 Testing Scripts (scripts/testing/)

| Script | Description | When to Use |
|--------|-------------|-------------|
| **`test_gpu.py`** | GPU performance testing | ทดสอบ performance และ GPU utilization |
| **`validate_gpu_setup.py`** | ตรวจสอบการติดตั้งครบถ้วน | หลังติดตั้งเสร็จ validate ทุกอย่าง |
| **`check_llama_cuda.py`** | CUDA compatibility check | ตรวจสอบ CUDA support |

#### 🛠️ Utility Scripts (scripts/utilities/)

| Script | Description | When to Use |
|--------|-------------|-------------|
| **`build_faiss_index.py`** | สร้าง vector stores ใหม่ | เมื่อต้องการ rebuild หรือเพิ่มข้อมูล |
| **`fix_faiss_compatibility.py`** | แก้ไข FAISS API compatibility | เมื่อมี FAISS import errors |

---

### 🤖 Installation Scripts

#### 🎯 Main Installation Scripts (issue/)

| Script | Description | When to Use |
|--------|-------------|-------------|
| **`setup_complete_gpu.bat`** | GPU setup ครบชุด (updated) | ติดตั้ง GPU support แบบ automated |
| **`install_menu.bat`** | เมนูติดตั้งแบบโต้ตอบ | เลือกการติดตั้งแบบ interactive |
| **`diagnose_llama_cpp.bat`** | วินิจฉัยและแก้ไขปัญหา | เมื่อมีปัญหา llama-cpp-python |

#### 🎯 Platform-specific Scripts

**Windows Scripts (setup/windows/)**
| Script | Description | When to Use |
|--------|-------------|-------------|
| **`auto_setup_windows.bat`** | ติดตั้ง prerequisites | เครื่องใหม่ที่ต้องการ CUDA/Build Tools |
| **`setup_python_env_windows.bat`** | Python environment setup | หลังจากมี prerequisites |
| **`download_models_windows.bat`** | ดาวน์โหลด LLM models | หลังจาก Python env พร้อม |
| **`run_app_windows.bat`** | รัน application | เมื่อติดตั้งเสร็จแล้ว |

**Linux Scripts (setup/linux/)**
| Script | Description | When to Use |
|--------|-------------|-------------|
| **`auto_setup.sh`** | ติดตั้ง system dependencies | เครื่องใหม่ที่ยังไม่มี CUDA/Python |
| **`setup_python_env.sh`** | ติดตั้ง Python environment | หลังจากติดตั้ง system deps |
| **`download_models.sh`** | ดาวน์โหลด LLM models | หลังจากติดตั้ง Python env |
| **`run_app.sh`** | รัน application | เมื่อติดตั้งเสร็จแล้ว |

---

### 📊 Quick Reference

#### 🛣️ Installation Paths

| Component | Windows Path | Linux Path |
|-----------|--------------|------------|
| **LLM Model** | `C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf` | `~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf` |
| **Embedding Model** | `C:\AI\embedding-models\all-MiniLM-L6-v2` | `~/Documents/AI/embedding-models/all-MiniLM-L6-v2` |
| **Virtual Environment** | `llm_rag_env\` | `llm_rag_env/` |
| **Vector Stores** | `data\embeddings\vector store\` | `data/embeddings/vector store/` |
| **Source Documents** | `data\sources\` | `data/sources/` |

#### ⚡ Performance Reference

| Setup | Speed (tokens/sec) | GPU Support | VRAM Usage | Difficulty |
|-------|-------------------|-------------|------------|------------|
| **Windows + GPU (RTX 2060)** | 25-35+ | ✅ | 2-3GB | Medium |
| **Linux + GPU** | 30-40+ | ✅ | 2-3GB | Medium |
| **CPU only** | 8-12 | ❌ | 3-4GB RAM | Easy |
| **WSL2 + GPU** | 30-40+ | ✅ | 2-3GB | Hard |

#### 🎯 New Project Structure

| Directory | Contents | Purpose |
|-----------|----------|---------|
| **`scripts/testing/`** | test_gpu.py, validate_gpu_setup.py, check_llama_cuda.py | Testing & validation |
| **`scripts/utilities/`** | build_faiss_index.py, fix_faiss_compatibility.py | Utility scripts |
| **`data/sources/`** | PDF, TXT documents | Source documents |
| **`data/embeddings/`** | Vector stores (FAISS) | Pre-built knowledge base |
| **`docs/`** | Documentation files | All documentation |
| **`docs/troubleshooting/`** | Troubleshooting guides | Problem resolution |

#### 🔍 Troubleshooting Flowchart

```
มีปัญหา? → ลองตามนี้:
│
├── Import Error → diagnose_llama_cpp.bat
├── FAISS Error → FAISS_FIX_GUIDE.md  
├── GPU ไม่ทำงาน → LLAMA_CPP_PYTHON_TROUBLESHOOTING.md
├── Performance ช้า → ตรวจสอบ GPU usage ใน log
└── อื่นๆ → WINDOWS_SETUP.md หรือ SETUP_GUIDE.md
```

---

### 🎯 Recommended Installation Flow

#### 👑 สำหรับผู้ใช้ใหม่ (Windows):
1. อ่าน [README.md](../README.md) สำหรับภาพรวม
2. รัน `.\issue\setup_complete_gpu.bat` (GPU support)
3. หรือรัน `.\issue\install_menu.bat` (interactive menu)
4. ทดสอบด้วย `python scripts\testing\validate_gpu_setup.py`
5. หากมีปัญหา อ่าน [troubleshooting/](troubleshooting/)

#### 👑 สำหรับผู้ใช้ใหม่ (Linux):
1. อ่าน [README.md](../README.md) สำหรับภาพรวม
2. รัน `setup/linux/auto_setup.sh`
3. รัน `setup/linux/setup_python_env.sh`
4. รัน `setup/linux/download_models.sh`
5. ทดสอบด้วย `python scripts/testing/test_gpu.py`

#### 🔧 สำหรับ Advanced Users:
1. อ่าน [setup/README.md](../setup/README.md)
2. เลือก scripts ตามความต้องการ
3. ใช้ utility scripts ใน `scripts/utilities/`
4. ปรับแต่งตาม environment

#### 🚨 สำหรับการแก้ปัญหา:
1. รัน `python scripts/testing/validate_gpu_setup.py`
2. อ่าน [troubleshooting guides](troubleshooting/)
3. ใช้ alternative methods หากจำเป็น
4. ตรวจสอบ performance ด้วย `scripts/testing/test_gpu.py`

---

### 📞 Support Information

- **Primary Documentation**: อยู่ในโฟลเดอร์ `setup/`
- **Troubleshooting**: ดูไฟล์ `*_TROUBLESHOOTING.md`
- **Scripts**: อยู่ในโฟลเดอร์ root และ `setup/windows/`, `setup/linux/`
- **Quick Help**: รัน `diagnose_llama_cpp.bat` (Windows) สำหรับ automated troubleshooting

### 📝 Documentation Updates

เอกสารทั้งหมดได้รับการอัพเดตให้มี:
- ✅ LLM path ที่ถูกต้อง (`C:\AI\llm\` สำหรับ Windows)
- ✅ คำแนะนำการติดตั้งแบบละเอียด
- ✅ Troubleshooting guides ครบถ้วน
- ✅ Installation scripts ที่ทำงานได้จริง
- ✅ Performance benchmarks และ tips
- ✅ Alternative solutions สำหรับกรณีที่ติดตั้งปกติไม่ได้
