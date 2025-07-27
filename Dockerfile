FROM python:3.9-slim

WORKDIR /app

# Install minimal dependencies
RUN pip install --no-cache-dir uuid

# Copy the inference stub script
COPY inference_stub.py .

# Entrypoint
CMD ["python", "inference_stub.py"]
