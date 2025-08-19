@echo off
echo === Extreme GPU Setup for llama-cpp-python ===
echo.

echo === Uninstalling existing llama-cpp-python ===
python -m pip uninstall llama-cpp-python -y

echo.
echo === Setting environment variables ===
set CMAKE_ARGS=-DLLAMA_CUBLAS=on -DCMAKE_CUDA_ARCHITECTURES=all
set FORCE_CMAKE=1
set CUDACXX=%CUDA_PATH%\bin\nvcc.exe

echo CMAKE_ARGS=%CMAKE_ARGS%
echo FORCE_CMAKE=%FORCE_CMAKE%
echo CUDACXX=%CUDACXX%
echo CUDA_PATH=%CUDA_PATH%

echo.
echo === Installing from source (this will take 10-15 minutes) ===
python -m pip install llama-cpp-python --force-reinstall --no-cache-dir --config-settings=cmake.args="-DLLAMA_CUBLAS=on" --config-settings=cmake.define.CMAKE_CUDA_ARCHITECTURES="all" --verbose

echo.
echo === Verifying installation ===
python -c "import llama_cpp; print('Success! Version:', llama_cpp.__version__)"
python -c "from llama_cpp import Llama; print('Llama class imported successfully')"

echo.
echo === Setup complete ===
pause
