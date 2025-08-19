# LLM-RAG Installation & Troubleshooting

📦 โฟลเดอร์นี้รวบรวมไฟล์สำหรับการติดตั้งและแก้ปัญหา LLM-RAG Project บน Windows

## 🚀 เริ่มต้นใช้งาน (แนะนำ)

```powershell
.\issue\install_menu.bat
```

## 📁 ไฟล์หลักที่มีอยู่

### 🎯 เมนูหลัก
- **`install_menu.bat`** - เมนูเลือกวิธีการติดตั้ง (เริ่มต้นที่นี่)

### 🔧 สคริปต์การติดตั้ง
- **`complete_cpp_setup.bat`** - ติดตั้ง Visual Studio Build Tools แบบสมบูรณ์ (แนะนำ)
- **`setup_complete_gpu.bat`** - ติดตั้งแบบ Smart (GPU/CPU อัตโนมัติ)
- **`setup_cpu_only.bat`** - ติดตั้งแบบ CPU-only เท่านั้น
- **`install_alternative_llm.bat`** - ทางเลือกอื่น (Ollama/Transformers)

### 🔧 แก้ปัญหา
- **`fix_buildtools_installation.bat`** - แก้ปัญหาหลังติดตั้ง Build Tools
- **`diagnose_llama_cpp.bat`** - วินิจฉัยปัญหาระบบ

### 📖 เอกสาร
- **`LLAMA_CPP_PYTHON_TROUBLESHOOTING.md`** - คู่มือแก้ปัญหาโดยละเอียด

## 💡 วิธีการติดตั้ง

### 🥇 แนะนำสำหรับผู้ใช้ทั่วไป
1. **ติดตั้งสมบูรณ์**: รัน `complete_cpp_setup.bat` (ต้องการ Admin)
2. **ทางเลือกง่าย**: รัน `install_alternative_llm.bat` (ไม่ต้อง Admin)

### 🔧 สำหรับผู้ที่ติดตั้ง Build Tools แล้ว
1. **แก้ปัญหา**: รัน `fix_buildtools_installation.bat`
2. **ติดตั้งต่อ**: รัน `setup_complete_gpu.bat`

### 🖥️ สำหรับการใช้ CPU เท่านั้น
- รัน `setup_cpu_only.bat` (ต้องการ Build Tools)

## 🎯 การแก้ปัญหาหลัก

### ✅ แก้แล้ว
- **Path Configuration**: LLM model path อัปเดตเป็น `C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf`
- **FAISS Compatibility**: ใช้ faiss-cpu แทน

### 🔄 กำลังแก้
- **llama-cpp-python Installation**: มีหลายวิธีติดตั้งให้เลือก

## 📞 ต้องการความช่วยเหลือ

1. รัน `diagnose_llama_cpp.bat` เพื่อตรวจสอบระบบ
2. อ่าน `LLAMA_CPP_PYTHON_TROUBLESHOOTING.md` สำหรับวิธีแก้ปัญหา
3. ใช้เมนู `install_menu.bat` เพื่อเลือกวิธีติดตั้งที่เหมาะสม

---
**Last Updated**: 19 มกราคม 2025 | **Files**: 9 ไฟล์หลัก
