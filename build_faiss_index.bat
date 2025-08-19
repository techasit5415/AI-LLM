@echo off
chcp 65001 >nul
REM สคริปต์นี้จะถามชื่อ vector store ที่ต้องการสร้าง (naruto, snake, naruto_snake, all)
REM แล้วรัน Python script เดียวสำหรับทุกกรณี

call llm_rag_env\Scripts\activate.bat
python build_faiss_index.py

pause
