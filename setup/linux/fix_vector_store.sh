#!/bin/bash

# สคริปต์แก้ไข Vector Store และ rebuild FAISS index
# ใช้เมื่อเจอปัญหา KeyError: '__fields_set__'

echo "🔧 แก้ไข Vector Store และ rebuild FAISS index..."

# เปลี่ยนไปยัง project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$PROJECT_DIR"

# ลบ vector store เก่า
echo "🧹 ลบ vector store เก่า..."
rm -rf "data/embeddings/vector store/"*/index*
rm -rf "data/embeddings/vector store/"*/docstore.pkl

# เปิดใช้งาน virtual environment
echo "🔄 เปิดใช้งาน virtual environment..."
source llm_rag_env/bin/activate

# แก้ไข package compatibility
echo "🔧 แก้ไข package compatibility..."
pip install "numpy>=1.25.2,<2.0" sentence-transformers "huggingface-hub>=0.19.0" --quiet

# สร้าง FAISS index ใหม่
echo "🚀 สร้าง FAISS index ใหม่..."
python -c "
import sys
sys.path.append('scripts/utilities')
from build_faiss_index import *

# สร้าง index สำหรับทุก vector store
for store in ['naruto', 'snake', 'naruto_snake']:
    print(f'Building index for {store}...')
    build_index(store)
    print(f'Index for {store} completed.')

print('All FAISS indexes rebuilt successfully!')
"

echo "✅ แก้ไข Vector Store เสร็จสิ้น!"
echo "ตอนนี้สามารถรัน streamlit app ได้แล้ว"
