#!/bin/bash

# สคริปต์สำหรับสร้าง FAISS index บน Linux
# ลบไฟล์ index ในทั้ง 3 โฟลเดอร์ก่อนสร้างใหม่

# เปลี่ยนไปยัง directory ของโปรเจ็กต์
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "🧹 ลบไฟล์ index เก่า..."
rm -f "$PROJECT_DIR/data/embeddings/vector store/naruto/index"* 2>/dev/null
rm -f "$PROJECT_DIR/data/embeddings/vector store/snake/index"* 2>/dev/null
rm -f "$PROJECT_DIR/data/embeddings/vector store/naruto_snake/index"* 2>/dev/null

cd "$PROJECT_DIR"

echo "🔧 เปิดใช้งาน virtual environment..."
source llm_rag_env/bin/activate

echo "🔧 แก้ไข packages compatibility สำหรับ Linux..."
pip install "numpy>=1.25.2,<2.0" sentence-transformers "huggingface-hub>=0.19.0" --quiet

echo "🚀 รัน FAISS index builder..."
python scripts/utilities/build_faiss_index.py

echo ""
echo "✅ เสร็จสิ้น! กด Enter เพื่อออก..."
read -p ""
