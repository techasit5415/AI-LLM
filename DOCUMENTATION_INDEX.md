# LLM-RAG Documentation Index
## ดัชนีเอกสารครบชุดสำหรับ LLM-RAG Chatbot

### 📚 เอกสารหลัก

#### 🏠 [README.md](README.md)
เอกสารหลักของโปรเจค รวม:
- ภาพรวมระบบ
- การติดตั้งแบบย่อ
- วิธีใช้งานพื้นฐาน
- Performance benchmarks

#### 🛠️ [setup/README.md](setup/README.md)
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

#### 🚨 [LLAMA_CPP_PYTHON_TROUBLESHOOTING.md](LLAMA_CPP_PYTHON_TROUBLESHOOTING.md)
คู่มือแก้ปัญหา llama-cpp-python แบบละเอียด:
- ปัญหาที่พบบ่อยและสาเหตุ
- วิธีแก้ไขแบบ step-by-step (4 methods)
- การทดสอบและ verification
- Performance comparison
- Alternative solutions

#### 🔧 [FAISS_FIX_GUIDE.md](FAISS_FIX_GUIDE.md)
คู่มือแก้ปัญหา FAISS compatibility:
- แก้ไขปัญหา `allow_dangerous_deserialization`
- การอัพเดต packages
- ขั้นตอนการทดสอบ
- Package versions ที่แนะนำ

---

### 🤖 Installation Scripts

#### 🎯 Windows Scripts

| Script | Description | When to Use |
|--------|-------------|-------------|
| **`install_complete_detailed.bat`** | ติดตั้งครบชุดแบบละเอียด | เครื่องใหม่ที่ต้องการติดตั้งทุกอย่าง |
| **`diagnose_llama_cpp.bat`** | วินิจฉัยและแก้ไขปัญหา | เมื่อมีปัญหา llama-cpp-python |
| **`install_llama_cpp_gpu.bat`** | ติดตั้ง llama-cpp-python พร้อม GPU | หลังจากมี Visual Studio แล้ว |
| **`install_llama_alternative.bat`** | ติดตั้งทางเลือก | เมื่อติดตั้งปกติไม่ได้ |
| **`setup_complete_gpu.bat`** | ติดตั้งและตรวจสอบครบชุด | ตรวจสอบระบบและติดตั้ง |
| **`fix_faiss_windows.bat`** | แก้ไขปัญหา FAISS | เมื่อมี FAISS compatibility error |

#### 🎯 Linux Scripts

| Script | Description | When to Use |
|--------|-------------|-------------|
| **`auto_setup.sh`** | ติดตั้ง system dependencies | เครื่องใหม่ที่ยังไม่มี CUDA/Python |
| **`setup_python_env.sh`** | ติดตั้ง Python environment | หลังจากติดตั้ง system deps |
| **`download_models.sh`** | ดาวน์โหลด LLM models | หลังจากติดตั้ง Python env |
| **`run_app.sh`** | รัน application | เมื่อติดตั้งเสร็จแล้ว |

#### 🎯 Utility Scripts

| Script | Description | OS |
|--------|-------------|-----|
| **`fix_faiss_compatibility.py`** | ทดสอบ FAISS compatibility | Cross-platform |
| **`requirements_updated.txt`** | Package versions ที่เข้ากันได้ | Cross-platform |

---

### 📊 Quick Reference

#### 🛣️ Installation Paths

| Component | Windows Path | Linux Path |
|-----------|--------------|------------|
| **LLM Model** | `C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf` | `~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf` |
| **Embedding Model** | `C:\AI\embedding-models\all-MiniLM-L6-v2` | `~/Documents/AI/embedding-models/all-MiniLM-L6-v2` |
| **Virtual Environment** | `llm_rag_env\` | `llm_rag_env/` |
| **Vector Stores** | `vector store\` | `vector store/` |

#### ⚡ Performance Reference

| Setup | Speed (tokens/sec) | GPU Support | Difficulty |
|-------|-------------------|-------------|------------|
| **Linux + GPU** | 4000+ | ✅ | Medium |
| **Windows + GPU** | 3800+ | ✅ | Hard |
| **CPU only** | 2500-2700 | ❌ | Easy |
| **WSL2 + GPU** | 4000+ | ✅ | Hard |

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
1. อ่าน [README.md](README.md) สำหรับภาพรวม
2. รัน `install_complete_detailed.bat`
3. หากมีปัญหา รัน `diagnose_llama_cpp.bat`
4. อ่าน [LLAMA_CPP_PYTHON_TROUBLESHOOTING.md](LLAMA_CPP_PYTHON_TROUBLESHOOTING.md)

#### 👑 สำหรับผู้ใช้ใหม่ (Linux):
1. อ่าน [README.md](README.md) สำหรับภาพรวม
2. รัน `setup/linux/auto_setup.sh`
3. รัน `setup/linux/setup_python_env.sh`
4. รัน `setup/linux/download_models.sh`

#### 🔧 สำหรับ Advanced Users:
1. อ่าน [setup/README.md](setup/README.md)
2. เลือก scripts ตามความต้องการ
3. ปรับแต่งตาม environment

#### 🚨 สำหรับการแก้ปัญหา:
1. รัน diagnostic scripts ก่อน
2. อ่าน troubleshooting guides
3. ใช้ alternative methods หากจำเป็น

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
