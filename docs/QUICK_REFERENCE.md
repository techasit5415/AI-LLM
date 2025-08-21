# 🎯 LLM-RAG Installation Quick Reference

## 🚀 เริ่มต้นใช้งาน

รัน: `.\issue\install_menu.bat`

## � สร้าง Vector Store (หลังติดตั้งเสร็จ)

### Linux/Mac:
```bash
./scripts/utilities/build_faiss_index.sh
```

### Windows:
```cmd
scripts\utilities\build_faiss_index.bat
```

**เลือกได้ 4 แบบ:**
1. Snake Vector Store เท่านั้น
2. Naruto Vector Store เท่านั้น
3. Naruto + Snake Vector Store (รวม)
4. สร้างทั้งหมด (All)

## �📁 ไฟล์หลัก (9 ไฟล์)

| ไฟล์ | หน้าที่ | แนะนำ |
|------|---------|--------|
| `install_menu.bat` | 🎯 เมนูหลัก | ⭐ เริ่มต้นที่นี่ |
| `complete_cpp_setup.bat` | 🛠️ ติดตั้ง Build Tools | ⭐ แนะนำ Admin |
| `setup_complete_gpu.bat` | 🚀 Smart install | GPU/CPU อัตโนมัติ |
| `setup_cpu_only.bat` | 💻 CPU เท่านั้น | ต้องการ Build Tools |
| `install_alternative_llm.bat` | 🔄 ทางเลือก | Ollama/Transformers |
| `fix_buildtools_installation.bat` | 🔧 แก้ปัญหา | หลังติดตั้ง Build Tools |
| `diagnose_llama_cpp.bat` | 🔍 วินิจฉัย | ตรวจสอบระบบ |
| `LLAMA_CPP_PYTHON_TROUBLESHOOTING.md` | 📖 คู่มือ | แก้ปัญหาโดยละเอียด |
| `README.md` | 📋 อธิบาย | ไฟล์นี้ |

## 🎯 LLM Model Path

✅ **Windows**: `C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf`

## 💡 แนะนำการใช้งาน

1. **ผู้ใช้ทั่วไป**: `complete_cpp_setup.bat` (ต้อง Admin)
2. **ไม่ต้องการ Admin**: `install_alternative_llm.bat`
3. **มี Build Tools แล้ว**: `fix_buildtools_installation.bat`
4. **มีปัญหา**: `diagnose_llama_cpp.bat`

---
**Clean & Simple** | 19 ม.ค. 2025
