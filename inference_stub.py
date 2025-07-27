import json
import time
import uuid
from datetime import datetime, timezone
import os

LOG_FILE = "logs.jsonl"
MODEL_NAME = "test-model"

'''
Function to log events 
'''
def log_event(level, component, message, duration_ms=None):
    log_entry = {
        "timestamp": datetime.now(timezone.utc).isoformat(timespec='seconds').replace('+00:00', 'Z'),
        "level": level,
        "component": component,
        "message": message,
        "model": MODEL_NAME
    }
    if duration_ms is not None:
        log_entry["duration_ms"] = duration_ms
    
    with open(LOG_FILE, "a") as f:
        f.write(json.dumps(log_entry) + "\n")


'''
Function to mimic the behavior from inference service/method
'''
def stub_method_for_inference():
    # Check for the existance of input file
    if not os.path.exists("input.json"):
        log_event("ERROR", "inference", "Input file not found")
        exit(1)

    # Read input (just for demonstration)
    try:
        with open("input.json", "r") as f:
            input_data = json.load(f)
        log_event("INFO", "inference", f"Processing request {input_data.get('request_id', 'unknown')}")
    except Exception as e:
        log_event("ERROR", "inference", f"Error reading input: {str(e)}")
        exit(1)

    # Mock inference processing
    start_time = time.time()
    log_event("INFO", "inference", "Starting model processing")
    
    # Simulate processing time (1-2 seconds)
    time.sleep(1.5)
    
    # Generate mock output
    output_data = {
        "result": "success",
        "request_id": input_data.get("request_id", str(uuid.uuid4())),
        "confidence": 0.95,
        "processed_at": datetime.now(timezone.utc).isoformat()
    }
    
    # Write output
    try:
        with open("output.json", "w") as f:
            json.dump(output_data, f, indent=2)
    except Exception as e:
        log_event("ERROR", "inference", f"Error writing output: {str(e)}")
        exit(1)

    # Log completion
    duration_ms = int((time.time() - start_time) * 1000)
    log_event("INFO", "inference", "Model processing completed", duration_ms)

def main():
    stub_method_for_inference()

if __name__ == "__main__":
    main()
