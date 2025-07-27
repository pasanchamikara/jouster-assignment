#!/bin/bash

# gpu_metrics=$(nvidia-smi --query-gpu=temperature.gpu,memory.used,memory.total --format=noheader 2>/dev/null)

# if [ $? -ne 0 ] || [ ${#gpu_metrics[@]} -lt 3 ]; then
#    echo "ERROR: Failed to get GPU metrics" >&2
#    exit 1
#fi

#temperature=${gpu_metrics[0]}
#memory_used=${gpu_metrics[1]}
#memory_total=${gpu_metrics[2]}

# Get metrics and format as JSON
read -r -d '' json_output <<EOF
{
  "gpu_metrics": [
    $(nvidia-smi --query-gpu=temperature.gpu,memory.used,memory.total \
      --format=csv,noheader,nounits | awk -F', ' '{
        printf "{\"temperature\":%d,\"memory_used\":%d,\"memory_total\":%d}",
        $1,$2,$3
      }' | paste -sd,)
  ]
}
EOF

echo "$json_output" | jq '.'
