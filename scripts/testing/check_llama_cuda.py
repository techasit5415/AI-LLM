#!/usr/bin/env python3

import sys
import os
import os

try:
    from llama_cpp import Llama, llama_cpp
    import llama_cpp as lcp
    print("=== llama-cpp-python CUDA Support Check ===")
    print(f"llama-cpp-python version: {lcp.__version__}")
    
    # ตรวจสอบ CUDA support
    print("\nChecking CUDA support...")
    
    # Try to find CUDA symbols
    try:
        # ลองดู attributes ทั้งหมดที่เกี่ยวข้องกับ CUDA
        cuda_attrs = [attr for attr in dir(llama_cpp) if 'cuda' in attr.lower()]
        print(f"CUDA-related attributes: {cuda_attrs}")
        
        # ลองดู backend info
        if hasattr(llama_cpp, 'llama_print_system_info'):
            print("\nSystem info:")
            try:
                llama_cpp.llama_print_system_info()
            except Exception as e:
                print(f"Error getting system info: {e}")
        
        # ลองสร้าง model และดู verbose output
        print("\nTrying to create model with verbose=True...")
        import platform
        HOME = os.path.expanduser("~")
        if platform.system() == "Windows":
            model_path = os.path.join(HOME, "Documents", "AI", "llm", "Llama-3.2-3B-Instruct-GGUF", "Llama-3.2-3B-Instruct-Q5_K_M.gguf")
        else:
            model_path = os.path.join(HOME, "Documents", "AI", "llm", "Llama-3.2-3B-Instruct-GGUF", "Llama-3.2-3B-Instruct-Q5_K_M.gguf")

        if os.path.exists(model_path):
            # ลองสร้าง model โดยใช้ GPU
            llm = Llama(
                model_path=model_path,
                n_gpu_layers=-1,  # All layers to GPU
                verbose=True,
                n_ctx=512
            )
            print("\n✅ Model created successfully!")
            
            # Generate a small test
            output = llm("Test", max_tokens=5)
            print(f"Test output: {output}")
            
        else:
            print(f"❌ Model file not found: {model_path}")
            
    except Exception as e:
        print(f"❌ Error during CUDA check: {e}")
        import traceback
        traceback.print_exc()

except ImportError as e:
    print(f"❌ Error importing llama_cpp: {e}")
    sys.exit(1)
