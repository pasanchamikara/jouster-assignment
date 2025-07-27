## Minivault System Bootstrap

### Setup instructions for Ubuntu 22.04 LTS

For the scripts to run, there are a few requirements <br>

These do include the followings.

1. Task 1: diagnose.sh script


2. Task 2:  run_inference_stub.sh

3. Task 3: 

Bonus Task : GPU Health Monitoring - Make sure jq is installed for json processing.
if not 

```
sudo apt update && sudo apt install jq would install it.
```

Also, in this case, we were considering of a single GPU scenario per computer. But in case there were multiple GPUs the structuring of the script would differe a bit as, it should output statistics for the separate 

Bonus Task : Mock Telemetry - This is an API endpoint created via flask, such that the data could be passed in the format.

```
curl -X POST http://localhost:5000/logs \\n  -H "Content-Type: application/json" \\n  -d '{"timestamp": "2025-07-27T10:30:00Z", "level": "INFO", "component": "inference", "message": "Model processing completed", "model": "test-model", "duration_ms": 1500}'\n
```

for local running cases, the port is exposed at port 5000, so make sure that the specific port is available, if not, you can change the port from the code, and if Docker containerization is used the amendment has to happen in Dockerfile as well.

for local executing, create a python virtual environment and use that to install the related dependencies. 

```
apt install python-venv
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python telemetry_server.py
``` 

### Assumptions and Design Decisions
There were a few assumptions and design decisions that we had to take.

Some do include the followings. 

So we assume, 
1. Only NVIDIA GPUs were available as GPUs, and if not NVIDIA ones, no GPUs were utilized
2. There are instances where drivers are not installed even if NVIDIA GPUs were setup
3. There were instances where CUDA was not installed even if NVIDA GPUs were setup
4. Assume that the future package versions do not change the executing bin file names

#### System Diagnostic Script (diagnose.sh)

#### Container Setup (run_inference_stub.sh)

#### Structured Logging



### How to expand this for real model deployment
For real model deployment, there are a few more concerns which would need to be addressed. Because, that would require increasing the reusability with refactoring as well as utilizing GPU for containers running models.

So for containers running models, it would be required to check for the availability of NVIDIA container toolkit as well, as it would help in briding the GPU resources across docker containers.

In modern cloud accelerated GPU systems, there exists more than 1 GPUs, therefore, in cases like 


### Bonus Task

In my case, I have implemented 2 of the 3 bonus tasks, I could implement the third one as well, but due to time constraints and with the possibility of the need of some additional information, I have opted for the following 2 task.
<br>
GPU health monitoring script - gpu_health_monitoring.sh
Mock Telemetry: Simple HTTP server endpoint accepting log data via POST (But in this case any auth system has not been provided)


I have selected the implementation of Telemetry Server for log processing. The content of the implementation are located within `./telemetry_server` of the repo home.

The telemetry server is dockerized, and implementation is listed below.
