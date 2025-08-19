@echo off
chcp 65001 >nul
REM ลบไฟล์ index ในทั้ง 3 โฟลเดอร์ก่อนสร้างใหม่
cd /d "%~dp0"
del /q "..\..\data\embeddings\vector store\naruto\index*.*" 2>nul
del /q "..\..\data\embeddings\vector store\snake\index*.*" 2>nul
del /q "..\..\data\embeddings\vector store\naruto_snake\index*.*" 2>nul
cd /d "%~dp0..\.."
REM สคริปต์นี้จะถามชื่อ vector store ที่ต้องการสร้าง (naruto, snake, naruto_snake, all)
REM แล้วรัน Python script เดียวสำหรับทุกกรณี

call llm_rag_env\Scripts\activate.bat
python scripts\utilities\build_faiss_index.py

pause
