#!/bin/bash

# Configuration
INPUT_FILE="input.json"
OUTPUT_FILE="output.json"
LOG_FILE="inference_logs.jsonl"
MODEL_NAME="test-model"
CONTAINER_NAME="inference-stub"

# Initialize JSONL log file
echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "level": "INFO", "component": "bootstrap", "message": "Starting inference stub", "model": "'$MODEL_NAME'"}' >> $LOG_FILE

# Check for required files
if [ ! -f "$INPUT_FILE" ]; then
    echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "level": "ERROR", "component": "bootstrap", "message": "Input file missing: '$INPUT_FILE'", "model": "'$MODEL_NAME'"}' >> $LOG_FILE
    exit 1
fi

# Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "level": "ERROR", "component": "bootstrap", "message": "Docker daemon not running", "model": "'$MODEL_NAME'"}' >> $LOG_FILE
    exit 1
fi

# Build the image if not exists
if ! docker image inspect $MODEL_NAME >/dev/null 2>&1; then
    echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "level": "INFO", "component": "bootstrap", "message": "Building Docker image", "model": "'$MODEL_NAME'"}' >> $LOG_FILE
    docker build -t $MODEL_NAME -f Dockerfile . || {
        echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "level": "ERROR", "component": "bootstrap", "message": "Docker build failed", "model": "'$MODEL_NAME'"}' >> $LOG_FILE
        exit 1
    }
fi

# Run the container
echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "level": "INFO", "component": "bootstrap", "message": "Starting inference container", "model": "'$MODEL_NAME'"}' >> $LOG_FILE

docker run --rm \
    --name $CONTAINER_NAME \
    -v $(pwd)/$INPUT_FILE:/app/input.json \
    -v $(pwd)/$OUTPUT_FILE:/app/output.json \
    -v $(pwd)/$LOG_FILE:/app/logs.jsonl \
    $MODEL_NAME || {
    echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "level": "ERROR", "component": "bootstrap", "message": "Container execution failed", "model": "'$MODEL_NAME'"}' >> $LOG_FILE
    exit 1
}

echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'", "level": "INFO", "component": "bootstrap", "message": "Inference completed successfully", "model": "'$MODEL_NAME'"}' >> $LOG_FILE
