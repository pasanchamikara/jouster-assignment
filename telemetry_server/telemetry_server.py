from flask import Flask, request, jsonify
import json
import datetime
import os

app = Flask(__name__)
LOG_FILE = "telemetry_logs.jsonl"

# Ensure log file exists
if not os.path.exists(LOG_FILE):
    with open(LOG_FILE, "w"): pass

@app.route('/logs', methods=['POST'])
def receive_log():
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400

    data = request.get_json()

    # Basic schema validation (optional)
    required_fields = {"timestamp", "level", "component", "message"}
    if not required_fields.issubset(data.keys()):
        return jsonify({"error": f"Missing required fields: {required_fields - data.keys()}"}), 400

    # Append log to file
    try:
        with open(LOG_FILE, "a") as f:
            f.write(json.dumps(data) + "\n")
        print(f"Received log: {data}")
        return jsonify({"status": "success"}), 200
    except Exception as e:
        return jsonify({"error": f"Failed to write log: {str(e)}"}), 500

@app.route('/', methods=['GET'])
def index():
    return "Mock Telemetry Server Running"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

