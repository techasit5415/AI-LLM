# Vector Store Build Scripts

สคริปต์เหล่านี้ใช้สำหรับสร้าง vector store ใหม่หลังจากการแก้ไขปัญหา "คำถามยาวเกินไป"

## สคริปต์หลัก (เลือกใช้ได้):

### 1. build_faiss_index.sh (Linux/Mac)
**การใช้งาน**: `./scripts/utilities/build_faiss_index.sh`

### 2. build_faiss_index.bat (Windows) 
**การใช้งาน**: `scripts\utilities\build_faiss_index.bat`

### ตัวเลือกที่มี:
1. **Snake Vector Store** - สร้างเฉพาะข้อมูล snake
2. **Naruto Vector Store** - สร้างเฉพาะข้อมูล naruto  
3. **Naruto + Snake Vector Store** - สร้างข้อมูลรวม
4. **สร้างทั้งหมด (All)** - สร้างทั้ง 3 vector store

## สคริปต์แยกย่อย (เรียกโดยตรง):

### 1. rebuild_snake_vector_final.py
- **วัตถุประสงค์**: สร้าง vector store ใหม่สำหรับข้อมูล snake
- **การใช้งาน**: `python scripts/utilities/rebuild_snake_vector_final.py`
- **ผลลัพธ์**: FAISS index ใหม่ขนาด 120 อักษรต่อ chunk

### 2. rebuild_naruto_vector_final.py
- **วัตถุประสงค์**: สร้าง vector store ใหม่สำหรับข้อมูล naruto
- **การใช้งาน**: `python scripts/utilities/rebuild_naruto_vector_final.py`
- **ผลลัพธ์**: FAISS index ใหม่ขนาด 120 อักษรต่อ chunk

### 3. rebuild_naruto_snake_vector_final.py
- **วัตถุประสงค์**: สร้าง vector store ใหม่สำหรับข้อมูล naruto+snake รวม
- **การใช้งาน**: `python scripts/utilities/rebuild_naruto_snake_vector_final.py`
- **ผลลัพธ์**: FAISS index ใหม่ขนาด 120 อักษรต่อ chunk

## คุณสมบัติที่แก้ไข:

1. **Chunk Size**: ลดลงเป็น 120 อักษร (จากเดิม 500-1000)
2. **Embedding Dimensions**: ใช้ 128 มิติสำหรับความเข้ากันได้
3. **Error Handling**: เพิ่มการจัดการข้อผิดพลาด
4. **Memory Management**: ปรับปรุงการใช้หน่วยความจำ
5. **Interactive Menu**: เลือกได้ว่าจะสร้าง vector store ไหน

## หมายเหตุ:

- สคริปต์เหล่านี้ใช้ StableSimpleEmbeddings ที่เข้ากันได้กับ FAISS
- ก่อนใช้งานต้องตรวจสอบให้แน่ใจว่ามีไฟล์ข้อมูลต้นฉบับใน `data/sources/`
- สคริปต์จะสร้างไฟล์ใหม่แทนที่ของเดิม
- ทดสอบการทำงานหลังสร้างเสร็จแล้ว

สร้างขึ้นเมื่อ: 21 สิงหาคม 2025
ประวัติ: แก้ไขปัญหา "คำถามยาวเกินไป" และ CUDA memory issues
