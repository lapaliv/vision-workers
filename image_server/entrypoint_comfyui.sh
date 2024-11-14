#!/bin/bash

cd /app/image_server
/usr/bin/bash setup.sh

cd /app/ComfyUI



vram_mode=${VRAM_MODE:-'--lowvram'}
warmup=$(echo ${WARMUP:-false} | tr '[:upper:]' '[:lower:]')
device=${DEVICE:-0}
port=${PORT:-6919}

if [ -n "$vram_mode" ]
then
    python main.py $vram_mode --cuda-device $device --disable-xformers
else
    python main.py --disable-xformers  --cuda-device $device
fi

#cleanup
