# FAISS Compatibility Fix Guide
## แก้ไขปัญหา "FAISS.__init__() got an unexpected keyword argument 'allow_dangerous_deserialization'"

### 🔍 สาเหตุของปัญหา
ปัญหานี้เกิดจาก version ของ `langchain-community` ที่เก่าเกินไป ไม่รองรับ parameter `allow_dangerous_deserialization` ใน FAISS.load_local()

### ⚡ วิธีแก้ไขด่วน

#### สำหรับ Windows:
```cmd
REM เปิดใช้งาน virtual environment
llm_rag_env\Scripts\activate.bat

REM อัพเดต packages
pip install --upgrade langchain==0.1.20 langchain-community==0.0.38

REM หรือรันสคริปต์แก้ไขอัตโนมัติ
fix_faiss_windows.bat
```

#### สำหรับ Linux:
```bash
# เปิดใช้งาน virtual environment
source llm_rag_env/bin/activate

# อัพเดต packages
pip install --upgrade langchain==0.1.20 langchain-community==0.0.38

# ทดสอบ compatibility
python fix_faiss_compatibility.py
```

### 🔧 การแก้ไขในโค้ด

ไฟล์ `pages/backend/rag_functions.py` ได้รับการปรับปรุงให้รองรับทั้ง version เก่าและใหม่:

```python
# Load db with version compatibility
try:
    # สำหรับ langchain version ใหม่
    loaded_db = FAISS.load_local(
        f"vector store/{vector_store_list}", 
        instructor_embeddings, 
        allow_dangerous_deserialization=True
    )
except TypeError:
    # สำหรับ langchain version เก่า
    loaded_db = FAISS.load_local(
        f"vector store/{vector_store_list}", 
        instructor_embeddings
    )
```

### 📋 Package Versions ที่แนะนำ

```
langchain==0.1.20
langchain-community==0.0.38
faiss-cpu==1.7.4
sentence-transformers==2.2.2
streamlit==1.29.0
```

### 🧪 การทดสอบ

รันสคริปต์ทดสอบ:
```bash
python fix_faiss_compatibility.py
```

สคริปต์นี้จะ:
- ตรวจสอบ package versions
- ทดสอบการโหลด vector stores
- แสดงสถานะการทำงานของ FAISS

### 🚨 หากยังแก้ไขไม่ได้

1. **ลบและติดตั้ง packages ใหม่:**
```bash
pip uninstall langchain langchain-community faiss-cpu
pip install langchain==0.1.20 langchain-community==0.0.38 faiss-cpu==1.7.4
```

2. **สร้าง virtual environment ใหม่:**
```bash
# Backup vector stores และไฟล์สำคัญ
# ลบ virtual environment เก่า
rm -rf llm_rag_env  # Linux
rmdir /s llm_rag_env  # Windows

# สร้างใหม่และติดตั้ง packages
python -m venv llm_rag_env
source llm_rag_env/bin/activate  # Linux
llm_rag_env\Scripts\activate.bat  # Windows

pip install -r requirements_updated.txt
```

3. **ใช้ conda แทน pip (Windows):**
```cmd
conda create -n llm_rag python=3.11
conda activate llm_rag
conda install -c conda-forge langchain faiss-cpu sentence-transformers streamlit
pip install llama-cpp-python pypdf
```

### ⚠️ หมายเหตุ

- เก็บ backup ของ `vector store/` folder ไว้ก่อนแก้ไข
- หาก vector stores เสียหาย สามารถสร้างใหม่ได้จาก `data sources/`
- ปัญหานี้เป็นเรื่องปกติใน langchain ecosystem ที่มีการเปลี่ยนแปลง API บ่อย

### 🎯 ผลลัพธ์ที่คาดหวัง

หลังจากแก้ไข:
- ✅ Application รันได้ปกติ
- ✅ Vector stores โหลดได้สำเร็จ  
- ✅ ไม่มี error เกี่ยวกับ `allow_dangerous_deserialization`
- ✅ RAG chatbot ทำงานได้เต็มประสิทธิภาพ
