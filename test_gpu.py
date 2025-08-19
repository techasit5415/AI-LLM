from llama_cpp import Llama
import os

print("=== Testing llama-cpp-python GPU Support ===")

# Test if CUDA is available
try:
    import subprocess
    result = subprocess.run(['nvidia-smi'], capture_output=True, text=True)
    if result.returncode == 0:
        print("✅ NVIDIA GPU detected")
    else:
        print("❌ No NVIDIA GPU detected")
except:
    print("❌ nvidia-smi not available")

# Test loading model with GPU
model_path = r"C:\AI\llm\Llama-3.2-3B-Instruct-GGUF\Llama-3.2-3B-Instruct-Q5_K_M.gguf"
if os.path.exists(model_path):
    print(f"✅ Model file found: {model_path}")
    
    try:
        print("🔄 Loading model with GPU support (n_gpu_layers=-1)...")
        llm = Llama(
            model_path=model_path,
            n_gpu_layers=-1,  # Use all GPU layers
            verbose=True      # Show detailed logs
        )
        print("✅ Model loaded successfully!")
        
        # Test inference
        print("🧪 Testing inference...")
        response = llm("Hello", max_tokens=10)
        print(f"Response: {response}")
        
    except Exception as e:
        print(f"❌ Error loading model: {e}")
        
        # Try CPU-only mode
        print("🔄 Trying CPU-only mode...")
        try:
            llm = Llama(
                model_path=model_path,
                n_gpu_layers=0,  # CPU only
                verbose=True
            )
            print("✅ Model loaded in CPU mode")
        except Exception as e2:
            print(f"❌ CPU mode also failed: {e2}")
else:
    print(f"❌ Model file not found: {model_path}")
