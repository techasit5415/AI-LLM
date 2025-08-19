# Git Repository Guidelines for LLM-RAG

## 📦 What to Commit (Include in Git)

### ✅ Essential Code Files:
```
✅ rag_chatbot.py
✅ rag_chatbot_windows.py  
✅ pages/backend/rag_functions.py
✅ requirements.txt
✅ README.md
✅ setup/ (entire directory with scripts and docs)
```

### ✅ Configuration Files:
```
✅ .gitignore
✅ pyproject.toml (if using Poetry)
✅ setup scripts (.sh and .bat files)
✅ documentation (.md files)
```

### ✅ Small Data Files (if legally allowed):
```
✅ data sources/wikipedia_naruto.txt (if under fair use)
✅ data sources/wikipedia_snake.txt (if under fair use)
✅ vector store/ (pre-built vector databases - optional*)
```

*Note: Vector stores can be large (hundreds of MB). Consider whether to include them.

---

## ❌ What NOT to Commit (Exclude from Git)

### ❌ Large Model Files:
```
❌ *.gguf files (LLM models - usually 2GB+)
❌ *.bin files (model weights)
❌ *.safetensors files
❌ embedding-models/ folder
❌ llm/ folder with downloaded models
```

### ❌ Virtual Environments:
```
❌ llm_rag_env/ (Python virtual environment)
❌ venv/
❌ env/
❌ __pycache__/
❌ *.pyc files
```

### ❌ System-specific Files:
```
❌ .vscode/ (IDE settings)
❌ .idea/ (PyCharm settings)
❌ .DS_Store (macOS)
❌ Thumbs.db (Windows)
❌ *.log files
❌ cuda-keyring_*.deb
```

### ❌ Temporary Files:
```
❌ tmp/
❌ *.tmp
❌ *.bak
❌ *.swp
```

---

## 🤔 Optional Files (Decide Case by Case)

### Vector Stores:
```
🤔 vector store/naruto/
🤔 vector store/snake/
🤔 vector store/naruto_snake/
```
**Consider:** These can be 50-200MB each. If included, users don't need to rebuild them.

### Poetry Lock File:
```
🤔 poetry.lock
```
**Consider:** Include for exact dependency versions, exclude for flexibility.

---

## 📋 Recommended Repository Structure

```
LLM-RAG/                       # ✅ Root directory
├── .gitignore                 # ✅ Git ignore rules
├── README.md                  # ✅ Main documentation
├── requirements.txt           # ✅ Python dependencies
├── rag_chatbot.py            # ✅ Linux main app
├── rag_chatbot_windows.py    # ✅ Windows main app
├── pages/                    # ✅ Backend code
│   └── backend/
│       └── rag_functions.py  # ✅ Core logic
├── setup/                    # ✅ Installation scripts
│   ├── README.md            # ✅ Setup documentation
│   ├── linux/               # ✅ Linux setup files
│   └── windows/             # ✅ Windows setup files
├── data sources/            # ✅ Source documents (if legal)
│   ├── wikipedia_naruto.txt
│   └── wikipedia_snake.txt
└── vector store/            # 🤔 Pre-built vectors (optional)
    ├── naruto/
    ├── snake/
    └── naruto_snake/

# ❌ These folders should NOT be in git:
├── llm_rag_env/             # ❌ Virtual environment
├── models/                  # ❌ Downloaded models
├── embedding-models/        # ❌ Embedding models
└── __pycache__/            # ❌ Python cache
```

---

## 🚀 Git Workflow Recommendations

### Initial Setup:
```bash
# Add all essential files
git add .gitignore README.md requirements.txt
git add rag_chatbot*.py pages/ setup/

# Add documentation and setup scripts
git add setup/*/
git add *.md

# Check what will be committed
git status

# Commit
git commit -m "Initial LLM-RAG chatbot setup with cross-platform support"
```

### Before Committing:
```bash
# Always check file sizes
git status
du -sh * | grep -E "(G|[0-9]{3}M)"  # Find large files

# Check what's ignored
git status --ignored

# Verify no models are staged
git diff --cached --name-only | grep -E "\.(gguf|bin|pth)$"
```

---

## ⚠️ Important Notes

### Model Files:
- **Never commit** .gguf files (they're 2GB+)
- **Users should download** models using provided scripts
- **Include download scripts** in setup/ folders

### Vector Stores:
- **Consider file size** before committing
- **Alternative:** Provide rebuild scripts instead
- **License check:** Ensure you can distribute processed data

### Environment Files:
- **Never commit** .env files with secrets
- **Never commit** virtual environments
- **Always commit** requirements.txt for reproducibility

### Documentation:
- **Always keep updated** README.md and setup guides
- **Version your documentation** with code changes
- **Include troubleshooting** in docs rather than issues

---

## 📂 Example .gitignore Summary

The `.gitignore` file has been updated to exclude:
- 🔒 Large model files (*.gguf, *.bin)
- 🐍 Python environments and cache
- 💻 IDE and system files  
- 📁 Downloaded model directories
- 🚫 Temporary and log files
- ⚙️ Build artifacts

This ensures your repository stays clean and manageable! 🎯
