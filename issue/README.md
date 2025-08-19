# LLM-RAG Installation & Troubleshooting

📦 โฟลเดอร์นี้รวบรวมไฟล์สำหรับการติดตั้งและแก้ปัญหา LLM-RAG Project บน Windows

## 🚀 เริ่มต้นใช้งาน (แนะนำ)

### 🎯 GPU Support (แนะนำ)
```powershell
.\issue\setup_complete_gpu.bat
```

### �️ เมนูแบบโต้ตอบ
```powershell
.\issue\install_menu.bat
```

## 📁 ไฟล์หลักที่มีอยู่

### 🔧 สคริปต์การติดตั้ง GPU
- **`setup_complete_gpu.bat`** - ติดตั้ง GPU support แบบครบชุด (อัปเดตล่าสุด)
- **`setup_cpu_only.bat`** - ติดตั้งแบบ CPU-only เท่านั้น

### 🎯 เมนูและทางเลือก
- **`install_menu.bat`** - เมนูเลือกวิธีการติดตั้งแบบโต้ตอบ
- **`install_alternative_llm.bat`** - ทางเลือกอื่น (Ollama/Transformers)

### 🔧 แก้ปัญหาและ Setup
- **`complete_cpp_setup.bat`** - ติดตั้ง Visual Studio Build Tools แบบสมบูรณ์
- **`fix_buildtools_installation.bat`** - แก้ปัญหาหลังติดตั้ง Build Tools
- **`diagnose_llama_cpp.bat`** - วินิจฉัยปัญหาระบบ

##  วิธีการติดตั้ง (อัปเดต)

### 🥇 แนะนำสำหรับผู้ใช้ใหม่
1. **GPU Support**: รัน `setup_complete_gpu.bat` (รองรับ RTX 2060+)
2. **ตรวจสอบผลลัพธ์**: รัน `python ..\scripts\testing\validate_gpu_setup.py`
3. **ทดสอบ Performance**: รัน `python ..\scripts\testing\test_gpu.py`

### 🔧 สำหรับผู้ที่ติดตั้ง Build Tools แล้ว
1. **แก้ปัญหา**: รัน `fix_buildtools_installation.bat`
2. **ติดตั้งต่อ**: รัน `setup_complete_gpu.bat`

### 🖥️ สำหรับการใช้ CPU เท่านั้น
- รัน `setup_cpu_only.bat` (ต้องการ Build Tools)

### �️ สำหรับผู้ต้องการเลือกเอง
- รัน `install_menu.bat` (เมนูแบบโต้ตอบ)

## 📊 Performance ที่คาดหวัง

| Setup | Speed (tokens/sec) | VRAM Usage | Status |
|-------|-------------------|------------|--------|
| **RTX 2060 + GPU** | 25-35+ | 2-3GB | ✅ Validated |
| **CPU only** | 8-12 | 3-4GB RAM | ✅ Working |

## �🎯 การแก้ปัญหาหลัก

### ✅ อัปเดตล่าสุด
- **GPU Installation Method**: ใช้ direct wheel download (proven method)
- **Performance Metrics**: อัปเดตจากการทดสอบจริง (31.35 tokens/sec)
- **Error Handling**: เพิ่ม fallback methods หลายระดับ
- **Path Configuration**: LLM model path ยืนยันที่ `C:\AI\llm\`

### 🔄 การปรับปรุงต่อเนื่อง
- **Installation Reliability**: ลด dependency conflicts
- **User Experience**: ข้อความภาษาไทยที่ชัดเจน
- **Troubleshooting**: คู่มือแก้ปัญหาที่ครบถ้วน

## 📚 เอกสารที่เกี่ยวข้อง

### 🔗 เอกสารใหม่ (ย้ายไป docs/)
- **Troubleshooting Guide**: `../docs/troubleshooting/LLAMA_CPP_PYTHON_TROUBLESHOOTING.md`
- **GPU Setup Updates**: `../docs/troubleshooting/GPU_SETUP_UPDATES.md`
- **Quick Reference**: `../docs/QUICK_REFERENCE.md`

### 🧪 Scripts ทดสอบ (ย้ายไป scripts/)
- **GPU Performance Test**: `../scripts/testing/test_gpu.py`
- **Setup Validation**: `../scripts/testing/validate_gpu_setup.py`
- **CUDA Check**: `../scripts/testing/check_llama_cuda.py`

## 📞 ต้องการความช่วยเหลือ

### 🔍 ขั้นตอนแรก
1. รัน `diagnose_llama_cpp.bat` เพื่อตรวจสอบระบบ
2. รัน `python ..\scripts\testing\validate_gpu_setup.py` เพื่อตรวจสอบการติดตั้ง

### 📖 อ่านเอกสาร
1. ดู `../docs/troubleshooting/` สำหรับคู่มือแก้ปัญหา
2. ดู `../docs/DOCUMENTATION_INDEX.md` สำหรับดัชนีเอกสารทั้งหมด

### 🎛️ ทางเลือกอื่น
- ใช้เมนู `install_menu.bat` เพื่อเลือกวิธีติดตั้งที่เหมาะสม
- ลองทางเลือกอื่นใน `install_alternative_llm.bat`

---
**Last Updated**: 20 สิงหาคม 2025 | **GPU Method**: Direct wheel download | **Performance**: 31.35 tokens/sec validated
