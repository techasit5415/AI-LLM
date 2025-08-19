# Issue & Troubleshooting Files

โฟลเดอร์นี้รวบรวมไฟล์ทั้งหมดที่เกี่ยวข้องกับการแก้ปัญหาและการติดตั้ง LLM-RAG Project

## 📁 File Organization

### 🔧 Installation Scripts
- `install_menu.bat` - 🎯 **เมนูหลัก** เลือกวิธีการติดตั้งที่เหมาะสม
- `complete_cpp_setup.bat` - 🛠️ **ติดตั้งสมบูรณ์** Visual Studio C++ Tools (ใหม่!)
- `fix_buildtools_installation.bat` - 🔧 **แก้ปัญหา** หลังติดตั้ง Build Tools (ใหม่!)
- `setup_complete_gpu.bat` - 🚀 สคริปต์หลักติดตั้งแบบครบชุด (GPU/CPU ตามเงื่อนไข)
- `setup_cpu_only.bat` - 💻 ติดตั้งแบบ CPU-only เท่านั้น ⚠️ **ต้องการ Build Tools**
- `quick_install_wheels.bat` - ⚡ **ติดตั้งด่วน** ใช้ pre-compiled wheels (ใหม่!)
- `install_alternative_llm.bat` - 🔄 **ทางเลือกอื่น** Ollama/Transformers (ใหม่!)
- `install_complete_detailed.bat` - สคริปต์ติดตั้งแบบละเอียด พร้อมการจัดการข้อผิดพลาด
- `install_llama_alternative.bat` - วิธีการติดตั้ง llama-cpp-python ทางเลือกอื่น
- `install_llama_cpp_gpu.bat` - ติดตั้ง llama-cpp-python พร้อม GPU support
- `fix_faiss_windows.bat` - แก้ปัญหา FAISS
- `test_performance.bat` - 📊 ทดสอบประสิทธิภาพหลังการติดตั้ง

### 🔍 Diagnostic Tools
- `diagnose_llama_cpp.bat` - เครื่องมือวินิจฉัยปัญหา llama-cpp-python

### 📖 Documentation
- `LLAMA_CPP_PYTHON_TROUBLESHOOTING.md` - คู่มือแก้ปัญหา llama-cpp-python
- `DOCUMENTATION_INDEX.md` - ดัชนีเอกสารทั้งหมด
- `README.md` - ไฟล์นี้

## 🚀 Quick Start

### 🎯 เริ่มต้นใช้งาน (แนะนำ):
```bash
.\issue\install_menu.bat
```

### 💡 ทางเลือกการติดตั้ง:

#### 🚀 **สำหรับผู้ใช้ทั่วไป (แนะนำ)**:
1. **ติดตั้งสมบูรณ์ (แนะนำที่สุด)**: `complete_cpp_setup.bat` 🛠️ ⭐
   - ติดตั้ง Visual Studio Build Tools ครบชุด
   - ตั้งค่า environment อัตโนมัติ
   - รองรับ Admin permissions

2. **ทางเลือกอื่น (ไม่ต้อง Build Tools)**: `install_alternative_llm.bat` 🔄
   - Ollama: ใช้งานง่าย จัดการโมเดลอัตโนมัติ
   - Transformers: เสถียร รองรับโมเดลหลากหลาย

#### 🔧 **สำหรับผู้ที่ติดตั้ง Build Tools แล้ว**:
1. **แก้ปัญหาหลังติดตั้ง**: `fix_buildtools_installation.bat` 🔧
   - สำหรับที่ติดตั้ง Build Tools แล้วแต่ยังใช้ไม่ได้
   - ตรวจสอบและแก้ไข environment

2. **ติดตั้งด่วน**: `quick_install_wheels.bat` ⚡
   - ใช้ pre-compiled wheels ไม่ต้อง compile
   - เหมาะกับระบบที่มี Build Tools ครบแล้ว

#### 🛠️ **สำหรับผู้ที่ต้องการ Custom**:
1. **ติดตั้งแบบ Smart**: `setup_complete_gpu.bat`
   - ตรวจสอบระบบอัตโนมัติ GPU/CPU
   - มีตัวเลือกสำรองหากไม่สำเร็จ

2. **ติดตั้งแบบ CPU-only**: `setup_cpu_only.bat`
   - ต้องการ Visual Studio Build Tools

### 🔧 สำหรับแก้ปัญหา:
1. **วินิจฉัยปัญหา**: `diagnose_llama_cpp.bat`
2. **ทดสอบประสิทธิภาพ**: `test_performance.bat`
3. **แก้ปัญหา FAISS**: `fix_faiss_windows.bat`

## 🎯 Main Issues Addressed

### llama-cpp-python Installation
- **ปัญหา**: ImportError, missing C++ compiler
- **โซลูชัน**: Pre-compiled wheels, Visual Studio Build Tools
- **สถานะ**: In Progress

### FAISS Compatibility
- **ปัญหา**: Version conflicts on Windows
- **โซลูชัน**: faiss-cpu installation
- **สถานะ**: Fixed

### Path Configuration
- **ปัญหา**: Incorrect LLM model paths
- **โซลูชัน**: Updated to C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\
- **สถานะ**: Completed ✅

## 📞 Support

หากพบปัญหาเพิ่มเติม:
1. ตรวจสอบ DOCUMENTATION_INDEX.md
2. รัน diagnose_llama_cpp.bat
3. ดูรายละเอียดใน LLAMA_CPP_PYTHON_TROUBLESHOOTING.md

---
Created: 2025-01-19 | Last Updated: 2025-01-19
