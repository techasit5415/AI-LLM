# Testing Scripts - คู่มือการใช้งาน

โฟลเดอร์นี้รวบรวมสคริปต์สำหรับทดสอบการติดตั้งและประสิทธิภาพของระบบ AI-LLM

## 📋 สคริปต์ทดสอบ

### 1. `benchmark_llama_cpp.py`
- **วัตถุประสงค์**: ทดสอบประสิทธิภาพการโหลดและ inference ของ LLaMA model
- **คุณสมบัติ**: วัด tokens/second, เวลาโหลด model, เวลา generation
- **รองรับ**: Windows, Linux, macOS
- **ใช้งาน**: `python scripts/testing/benchmark_llama_cpp.py`

### 2. `check_llama_cuda.py`
- **วัตถุประสงค์**: ตรวจสอบ CUDA support ใน llama-cpp-python
- **คุณสมบัติ**: ตรวจสอบ CUDA build flags, system info, GPU layers
- **รองรับ**: Windows, Linux, macOS
- **ใช้งาน**: `python scripts/testing/check_llama_cuda.py`

### 3. `test_gpu.py`
- **วัตถุประสงค์**: ทดสอบการตรวจจับ GPU และการใช้งาน
- **คุณสมบัติ**: ตรวจสอบ nvidia-smi, โหลด model ด้วย GPU/CPU
- **รองรับ**: Windows, Linux, macOS
- **ใช้งาน**: `python scripts/testing/test_gpu.py`

### 4. `validate_gpu_setup.py`
- **วัตถุประสงค์**: ตรวจสอบการติดตั้งแบบครอบคลุม
- **คุณสมบัติ**: ตรวจสอบ import, CUDA support, PyTorch GPU, model loading
- **รองรับ**: Windows, Linux, macOS
- **ใช้งาน**: `python scripts/testing/validate_gpu_setup.py`

## 🚀 วิธีใช้งานแบบง่าย

### Windows
```bat
# รันสคริปต์เลือกเมนู
.\scripts\testing\run_test_scripts.bat

# หรือรันแต่ละไฟล์
python scripts/testing/benchmark_llama_cpp.py
```

### Linux/macOS
```bash
# รันสคริปต์เลือกเมนู
./scripts/testing/run_test_scripts.sh

# หรือรันแต่ละไฟล์
python3 scripts/testing/benchmark_llama_cpp.py
```

## ⚙️ ข้อกำหนดระบบ

### Python Packages ที่จำเป็น:
- `llama-cpp-python` - สำหรับ LLaMA model inference
- `torch` (ไม่บังคับ) - สำหรับตรวจสอบ PyTorch GPU
- `platform` - สำหรับตรวจสอบ OS (built-in)

### Model Files:
- สคริปต์จะหา model ใน path ต่างๆ โดยอัตโนมัติ:
  - `~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf`
  - `models/` directory
  - และ path อื่นๆ

## 🔧 การแก้ไขปัญหา

### ปัญหาที่พบบ่อย:

1. **ไม่พบ model file**
   - ดาวน์โหลด model ไฟล์ .gguf 
   - ปรับ path ใน script ให้ตรงกับตำแหน่งจริง

2. **CUDA not detected**
   - ตรวจสอบการติดตั้ง NVIDIA drivers
   - rebuild llama-cpp-python ด้วย CUDA support
   - ดู `docs/troubleshooting/LLAMA_CPP_PYTHON_TROUBLESHOOTING.md`

3. **Import Error**
   - ติดตั้ง packages: `pip install llama-cpp-python torch`
   - เปิดใช้งาน virtual environment

4. **Performance ต่ำ**
   - ตรวจสอบว่าใช้ GPU หรือ CPU-only
   - ปรับ `n_gpu_layers` parameter

## 📊 ตัวอย่าง Output

### Benchmark Result:
```
Loading model from: /path/to/model.gguf
Model loaded in 2.34 seconds.
Generating 64 tokens...
Generation time: 4.21 seconds
Tokens/sec: 15.20
```

### GPU Detection:
```
✅ NVIDIA GPU detected
✅ Model file found: /path/to/model.gguf
✅ Model loaded successfully!
```

## 🔗 เอกสารเพิ่มเติม

- [GPU Setup Updates](../../docs/troubleshooting/GPU_SETUP_UPDATES.md)
- [LLaMA CPP Python Troubleshooting](../../docs/troubleshooting/LLAMA_CPP_PYTHON_TROUBLESHOOTING.md)
- [Quick Reference](../../docs/QUICK_REFERENCE.md)

---
**สร้างเมื่อ**: August 2025  
**อัปเดตล่าสุด**: รองรับ cross-platform paths และ dynamic OS detection
