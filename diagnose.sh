#!/bin/bash

LOG_FILE="system_report.log"

# exit code 0 refers to no issues with the current setup
exit_code=0

# For logging in to a passed log file.
log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}


# For detecting if there is a NVIDIA GPU
# Returns 1 if no NVIDIA GPU is available
log "Detecting NVIDIA GPU"
if lspci | grep -i 'nvidia' > /dev/null; then
	log "NVIDIA GPU DETECTED"
else
	log "NO NVIDIA GPU DETECTED"
	exit_code=1
fi

# For detecting if NVIDIA driver exists
# Returns 2 if no NVIDIA Driver is found, but if there is NVIDIA GPU
log "Checking NVIDIA Driver"
if command -v nvidia-smi > /dev/null; then
	log "NVIDIA DRIVER installed"
	# nvidia-smi | tee -a "$LOG_FILE"
else
	log "NVIDIA DRIVER not found"
	if [ "$exit_code" -eq 0 ]; then exit_code=2; fi
fi

# For detecting if CUDA Toolkit exists
# Returns 3 if no CUDA toolkit is found, in the presence of both NVIDIA GPU and related drivers
log "Checking CUDA toolkit"
if command -v nvcc > /dev/null; then
	CUDA_VERSION=$(nvcc --version | grep "release" | sed 's/.*release //' | cut -d',' -f1)
	log 'CUDA TOOLKIT INSTALLED. VERSION $CUDA_VERSION'
else
	log 'CUDA TOOLKIT (nvcc) not found'
	if [ "$exit_code" -eq 0 ]; then exit_code=3; fi
fi

# For checking if Docker is installed
# Returns 4 if docker is not present, but all NVIDIA GPU, Driver, and CUDA toolkit is installted.
log "Checking Docker installation"
if command -v docker > /dev/null; then
	DOCKER_VERSION=$(docker --version)
	log "Docker is installed: $DOCKER_VERSION"
else
	log "Docker is not installed"
	if [ "$exit_code" -eq 0 ]; then exit_code=4; fi
fi

log "SYSTEM CHECK COMPLETED WITH EXIT CODE: $exit_code"
exit $exit_code
