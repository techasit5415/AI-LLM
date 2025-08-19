# APT packages required for LLM-RAG with GPU support

## CUDA Toolkit (for GPU acceleration)
sudo apt update
sudo apt install -y nvidia-cuda-toolkit

## Build tools and compilers
sudo apt install -y build-essential
sudo apt install -y cmake
sudo apt install -y git
sudo apt install -y wget
sudo apt install -y curl

## Python development
sudo apt install -y python3-dev
sudo apt install -y python3-pip
sudo apt install -y python3-venv

## System libraries for ML/AI packages
sudo apt install -y libblas-dev
sudo apt install -y liblapack-dev
sudo apt install -y libopenblas-dev
sudo apt install -y gfortran

## Graphics and image processing
sudo apt install -y libgl1-mesa-glx
sudo apt install -y libglib2.0-0
sudo apt install -y libsm6
sudo apt install -y libxext6
sudo apt install -y libxrender-dev
sudo apt install -y libgomp1

## PDF processing dependencies
sudo apt install -y poppler-utils

## Audio processing (for torchvision)
sudo apt install -y ffmpeg
sudo apt install -y libsndfile1

## Additional utilities
sudo apt install -y htop
sudo apt install -y tree
sudo apt install -y unzip

## NVIDIA drivers (if not already installed)
# sudo apt install -y nvidia-driver-535
# sudo reboot  # Required after driver installation

## Verify installations
echo "Checking installations..."
python3 --version
pip3 --version
nvcc --version  # Should show CUDA compiler version
nvidia-smi      # Should show GPU information
