import time
import os
from llama_cpp import Llama

import platform

# กำหนด path ให้รองรับทั้ง Windows และ Linux/macOS
HOME = os.path.expanduser("~")
if platform.system() == "Windows":
	# ตัวอย่าง path สำหรับ Windows (ปรับตามที่เก็บไฟล์จริง)
	MODEL_PATH = os.path.join(HOME, "Documents", "AI", "llm", "Llama-3.2-3B-Instruct-GGUF", "Llama-3.2-3B-Instruct-Q5_K_M.gguf")
else:
	MODEL_PATH = os.path.join(HOME, "Documents", "AI", "llm", "Llama-3.2-3B-Instruct-GGUF", "Llama-3.2-3B-Instruct-Q5_K_M.gguf")
PROMPT = "Tell me a joke about AI."
N_TOKENS = 64

print(f"Loading model from: {MODEL_PATH}")
start_load = time.time()
llm = Llama(model_path=MODEL_PATH, n_ctx=2048)
end_load = time.time()
print(f"Model loaded in {end_load - start_load:.2f} seconds.")

print(f"Generating {N_TOKENS} tokens...")
start_gen = time.time()
output = llm(PROMPT, max_tokens=N_TOKENS, echo=True)
end_gen = time.time()

generated = output['choices'][0]['text']
print("\n--- Output ---\n" + generated)
print(f"\nGeneration time: {end_gen - start_gen:.2f} seconds")
print(f"Tokens/sec: {N_TOKENS / (end_gen - start_gen):.2f}")
