import os
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain.text_splitter import CharacterTextSplitter

# กำหนด vector store และไฟล์ข้อมูลที่รองรับ
VECTOR_STORES = {
    "naruto": [os.path.join("data", "sources", "wikipedia_naruto.txt")],
    "snake": [os.path.join("data", "sources", "wikipedia_snake.txt")],
    "naruto_snake": [
        os.path.join("data", "sources", "wikipedia_naruto.txt"),
        os.path.join("data", "sources", "wikipedia_snake.txt")
    ]
}
EMBEDDING_MODEL_PATH = os.path.expanduser("~/Documents/AI/embedding-models/all-MiniLM-L6-v2")

print("Available vector stores:")
for name in VECTOR_STORES:
    print(f"- {name}")

selected = input("Enter vector store to build (naruto, snake, naruto_snake, all): ").strip().lower()

if selected == "all":
    targets = list(VECTOR_STORES.keys())
else:
    if selected not in VECTOR_STORES:
        print(f"Unknown vector store: {selected}")
        exit(1)
    targets = [selected]

for store in targets:
    VECTOR_STORE_DIR = os.path.join("data", "embeddings", "vector store", store)
    os.makedirs(VECTOR_STORE_DIR, exist_ok=True)
    # ลบ index เดิม
    for fname in ["index.faiss", "index.pkl"]:
        fpath = os.path.join(VECTOR_STORE_DIR, fname)
        if os.path.exists(fpath):
            os.remove(fpath)
    # รวมข้อความ
    all_text = ""
    for data_file in VECTOR_STORES[store]:
        with open(data_file, encoding="utf-8") as f:
            all_text += f.read() + "\n"
    # แบ่งข้อความ
    splitter = CharacterTextSplitter(chunk_size=500, chunk_overlap=50)
    docs = splitter.create_documents([all_text])
    # โหลด embedding model
    embeddings = HuggingFaceEmbeddings(model_name=EMBEDDING_MODEL_PATH)
    # สร้าง FAISS index
    print(f"Building FAISS index for {store} ...")
    db = FAISS.from_documents(docs, embeddings)
    db.save_local(VECTOR_STORE_DIR)
    print(f"Index saved to {VECTOR_STORE_DIR}\n")
print("Done.")
