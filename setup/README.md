# LLM-RAG Setup Directory Structure
## โครงสร้างโฟลเดอร์สำหรับติดตั้งระบบ

### 📁 Directory Structure
```
LLM-RAG/
├── rag_chatbot.py              # Main application (Linux/Windows)
├── rag_chatbot_windows.py      # Windows-specific version
├── requirements.txt            # Python dependencies
├── pages/                      # Backend modules
│   └── backend/
│       └── rag_functions.py
├── vector store/               # Pre-built vector databases
│   ├── naruto/
│   ├── snake/
│   └── naruto_snake/
├── data sources/               # Source documents
│   ├── wikipedia_naruto.txt
│   └── wikipedia_snake.txt
└── setup/                      # 🆕 Setup scripts directory
    ├── linux/                  # Linux setup files
    │   ├── auto_setup.sh           # ✅ System dependencies installer
    │   ├── setup_python_env.sh     # ✅ Python environment setup
    │   ├── download_models.sh       # ✅ Download LLM models
    │   ├── install_system_deps.sh   # ✅ Manual system packages install
    │   ├── run_app.sh              # ✅ Run application
    │   ├── SETUP_GUIDE.md          # 📖 Complete Linux setup guide
    │   └── QUICK_START.md          # 📖 Quick Linux setup guide
    └── windows/                # Windows setup files
        ├── auto_setup_windows.bat      # ✅ System check script
        ├── setup_python_env_windows.bat # ✅ Python environment setup
        ├── download_models_windows.bat  # ✅ Download LLM models
        ├── run_app_windows.bat         # ✅ Run application
        ├── WINDOWS_SETUP.md            # 📖 Complete Windows setup guide
        └── WINDOWS_QUICK_START.md      # 📖 Quick Windows setup guide
```

---

## 🐧 Linux Installation

### Quick Setup (Recommended):
```bash
cd LLM-RAG

# 1. Install system dependencies
setup/linux/auto_setup.sh
source ~/.bashrc

# 2. Setup Python environment  
setup/linux/setup_python_env.sh

# 3. Download models
setup/linux/download_models.sh

# 4. Run application
setup/linux/run_app.sh
```

### Manual Setup:
```bash
# Follow detailed instructions in:
setup/linux/SETUP_GUIDE.md
# Or quick guide:
setup/linux/QUICK_START.md
```

---

## 🖥️ Windows Installation

### Quick Setup (Recommended):
```cmd
cd LLM-RAG

REM 1. Check system requirements
setup\windows\auto_setup_windows.bat

REM 2. Setup Python environment
setup\windows\setup_python_env_windows.bat

REM 3. Download models to C:\AI\
setup\windows\download_models_windows.bat

REM 4. Run application
setup\windows\run_app_windows.bat
```

**LLM จะถูกติดตั้งที่:** `C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf`

### Manual Setup:
```cmd
REM Follow detailed instructions in:
setup\windows\WINDOWS_SETUP.md
REM Or quick guide:
setup\windows\WINDOWS_QUICK_START.md
```

---

## 📋 Setup Scripts Overview

### Linux Scripts (`setup/linux/`):
| Script | Purpose | When to Use |
|--------|---------|-------------|
| `auto_setup.sh` | ติดตั้ง system dependencies | เครื่องใหม่ที่ยังไม่มี CUDA/Python |
| `setup_python_env.sh` | ติดตั้ง Python environment | หลังจากติดตั้ง system deps แล้ว |
| `download_models.sh` | ดาวน์โหลด LLM models | หลังจากติดตั้ง Python env แล้ว |
| `install_system_deps.sh` | Manual system install | ถ้าต้องการติดตั้งทีละขั้นตอน |
| `run_app.sh` | รัน Streamlit application | เมื่อติดตั้งเสร็จแล้ว |

### Windows Scripts (`setup/windows/`):
| Script | Purpose | When to Use |
|--------|---------|-------------|
| `auto_setup_windows.bat` | ตรวจสอบระบบ Windows | เครื่องใหม่ที่ยังไม่แน่ใจว่ามีอะไรบ้าง |
| `setup_python_env_windows.bat` | ติดตั้ง Python environment | หลังจากติดตั้ง Prerequisites แล้ว |
| `download_models_windows.bat` | ดาวน์โหลด LLM models | หลังจากติดตั้ง Python env แล้ว |
| `run_app_windows.bat` | รัน Streamlit application | เมื่อติดตั้งเสร็จแล้ว |

---

## 🚀 One-Command Installation

### Linux:
```bash
cd LLM-RAG
setup/linux/auto_setup.sh && source ~/.bashrc && setup/linux/setup_python_env.sh && setup/linux/download_models.sh && setup/linux/run_app.sh
```
**LLM จะถูกติดตั้งที่:** `~/Documents/AI/llm/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct-Q5_K_M.gguf`

### Windows:
```cmd
cd LLM-RAG
setup\windows\auto_setup_windows.bat && setup\windows\setup_python_env_windows.bat && setup\windows\download_models_windows.bat && setup\windows\run_app_windows.bat
```
**LLM จะถูกติดตั้งที่:** `C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf`

---

## 📖 Documentation Files

### Linux Documentation:
- **`setup/linux/SETUP_GUIDE.md`** - Complete installation guide with troubleshooting
- **`setup/linux/QUICK_START.md`** - Fast installation for experienced users

### Windows Documentation:
- **`setup/windows/WINDOWS_SETUP.md`** - Complete Windows installation guide
- **`setup/windows/WINDOWS_QUICK_START.md`** - Fast Windows installation guide

---

## 🔧 Troubleshooting

### If scripts don't work:
1. **Linux:** Check script permissions: `chmod +x setup/linux/*.sh`
2. **Windows:** Run as Administrator or check PowerShell execution policy
3. **Both:** Read the detailed setup guides in respective OS folders

### Need help?
- **Linux users:** Read `setup/linux/SETUP_GUIDE.md`
- **Windows users:** Read `setup/windows/WINDOWS_SETUP.md`
- **Quick reference:** Check `setup/linux/QUICK_START.md` or `setup/windows/WINDOWS_QUICK_START.md`

---

## ⚡ Expected Performance
- **Linux + GPU:** ~4,000+ tokens/second
- **Windows + GPU:** ~3,800+ tokens/second  
- **CPU only (both):** ~2,500-2,700 tokens/second

---

## 📦 Files to Copy for New Installation

### Essential Files:
```
LLM-RAG/
├── rag_chatbot.py (Linux) / rag_chatbot_windows.py (Windows)
├── pages/backend/rag_functions.py
├── requirements.txt
├── vector store/ (entire folder)
├── data sources/ (entire folder)
└── setup/ (entire folder)
```

### Don't Need to Copy:
- Models (will be downloaded by scripts)
- Virtual environments (will be created by scripts)
- Cache files
