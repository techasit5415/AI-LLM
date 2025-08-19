#!/usr/bin/env python3
"""
Quick GPU Setup Validation Script
ตรวจสอบการติดตั้ง llama-cpp-python และ GPU support
"""

import sys
import time
import traceback

def print_header(title):
    print(f"\n{'='*50}")
    print(f"🔍 {title}")
    print(f"{'='*50}")

def check_basic_import():
    """ตรวจสอบการ import พื้นฐาน"""
    print_header("Basic Import Test")
    
    try:
        import llama_cpp
        print(f"✅ llama-cpp-python version: {llama_cpp.__version__}")
        return True
    except ImportError as e:
        print(f"❌ Cannot import llama_cpp: {e}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return False

def check_cuda_support():
    """ตรวจสอบ CUDA support"""
    print_header("CUDA Support Check")
    
    try:
        import llama_cpp.llama_cpp as llama_cpp_lib
        
        # ตรวจสอบ CUDA build flags
        if hasattr(llama_cpp_lib, 'GGML_USE_CUDA'):
            print("✅ CUDA support detected in build")
        else:
            print("⚠️ CUDA support not found - CPU-only build")
            
        return True
    except Exception as e:
        print(f"❌ Error checking CUDA support: {e}")
        return False

def check_torch_gpu():
    """ตรวจสอบ PyTorch GPU detection"""
    print_header("PyTorch GPU Detection")
    
    try:
        import torch
        print(f"PyTorch version: {torch.__version__}")
        print(f"CUDA available: {torch.cuda.is_available()}")
        
        if torch.cuda.is_available():
            print(f"GPU count: {torch.cuda.device_count()}")
            for i in range(torch.cuda.device_count()):
                gpu_name = torch.cuda.get_device_name(i)
                memory_total = torch.cuda.get_device_properties(i).total_memory / 1024**3
                print(f"GPU {i}: {gpu_name} ({memory_total:.1f}GB)")
        else:
            print("⚠️ No GPU detected by PyTorch")
            
        return True
    except ImportError:
        print("⚠️ PyTorch not installed - cannot check GPU")
        return True
    except Exception as e:
        print(f"❌ Error checking PyTorch GPU: {e}")
        return False

def test_model_loading():
    """ทดสอบการโหลดโมเดลแบบง่าย"""
    print_header("Model Loading Test")
    
    # หาโมเดลในระบบ
    import os
    possible_models = [
        "models/llama-2-7b-chat.Q4_K_M.gguf",
        "models/Llama-2-7b-Chat-GGUF/llama-2-7b-chat.Q4_K_M.gguf",
        "../models/llama-2-7b-chat.Q4_K_M.gguf"
    ]
    
    model_path = None
    for path in possible_models:
        if os.path.exists(path):
            model_path = path
            break
    
    if not model_path:
        print("⚠️ No model file found - skipping model loading test")
        print("💡 Download model with: python download_model.py")
        return True
    
    try:
        from llama_cpp import Llama
        
        print(f"📁 Loading model: {model_path}")
        print("⏳ This may take a few moments...")
        
        # ลองโหลดโมเดลแบบ GPU-enabled
        start_time = time.time()
        
        llm = Llama(
            model_path=model_path,
            n_gpu_layers=-1,  # ใช้ GPU ทั้งหมด
            verbose=True,
            n_ctx=512,  # context size เล็กสำหรับการทดสอบ
        )
        
        load_time = time.time() - start_time
        print(f"✅ Model loaded successfully in {load_time:.1f}s")
        
        # ทดสอบ inference
        print("🧪 Testing inference...")
        start_time = time.time()
        
        response = llm("Hello! How are you?", max_tokens=50, echo=False)
        
        inference_time = time.time() - start_time
        tokens_generated = len(response['choices'][0]['text'].split())
        tokens_per_sec = tokens_generated / inference_time if inference_time > 0 else 0
        
        print(f"✅ Inference completed")
        print(f"📊 Performance: {tokens_per_sec:.1f} tokens/sec")
        print(f"📝 Response preview: {response['choices'][0]['text'][:100]}...")
        
        return True
        
    except Exception as e:
        print(f"❌ Model loading failed: {e}")
        print("\n🔍 Error details:")
        traceback.print_exc()
        return False

def main():
    """Main validation function"""
    print("🚀 GPU Setup Validation Script")
    print("="*50)
    
    results = []
    
    # Test 1: Basic import
    results.append(check_basic_import())
    
    # Test 2: CUDA support
    results.append(check_cuda_support())
    
    # Test 3: PyTorch GPU
    results.append(check_torch_gpu())
    
    # Test 4: Model loading (optional)
    print("\n" + "="*50)
    test_model = input("🤔 ต้องการทดสอบการโหลดโมเดลด้วยหรือไม่? (y/n): ").lower().strip()
    
    if test_model == 'y':
        results.append(test_model_loading())
    
    # Summary
    print_header("Validation Summary")
    
    passed_tests = sum(results)
    total_tests = len(results)
    
    if passed_tests == total_tests:
        print(f"🎉 All tests passed! ({passed_tests}/{total_tests})")
        print("✅ GPU setup is ready for use")
    else:
        print(f"⚠️ Some tests failed ({passed_tests}/{total_tests})")
        print("💡 Check the error messages above for troubleshooting")
    
    print("\n💡 Next steps:")
    print("   - Run: streamlit run rag_chatbot.py")
    print("   - Run: python test_gpu.py (full performance test)")
    print("   - Check: ./issue/LLAMA_CPP_PYTHON_TROUBLESHOOTING.md")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⏹️ Validation cancelled by user")
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        traceback.print_exc()
    finally:
        print("\n" + "="*50)
        input("Press Enter to exit...")
