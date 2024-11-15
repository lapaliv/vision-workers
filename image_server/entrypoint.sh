#!/bin/bash

set -e;

if [ -d /app/ComfyUI ] && [ -z "$(ls -A /app/ComfyUI)" ]; then
  rm -rf /app/ComfyUI
fi

if [ ! -d /app/ComfyUI ] || [ -z "$(ls -A /app/ComfyUI)" ]; then
  git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI
  cd /app/ComfyUI
  git fetch --depth 1 origin f7a5107784cded39f92a4bb7553507575e78edbe
  git checkout f7a5107784cded39f92a4bb7553507575e78edbe
fi

vram_mode=${VRAM_MODE:-'--lowvram'}
warmup=$(echo ${WARMUP:-false} | tr '[:upper:]' '[:lower:]')
device=${DEVICE:-0}
port=${PORT:-6919}

#if [ -n "$vram_mode" ]
#then
#    python main.py $vram_mode --cuda-device $device --port $port --listen 127.0.0.1 &
##    python main.py $vram_mode --cuda-device $device --disable-xformers --port $port --listen 127.0.0.1
#else
#    python main.py --cuda-device $device --port $port --listen 127.0.0.1 &
#fi

cd /app/ComfyUI
pip install -r requirements.txt
if [ -n "$vram_mode" ]
then
    python main.py $vram_mode --cuda-device $device --disable-xformers --port 8188 --listen 127.0.0.1 &
else
    python main.py --disable-xformers  --cuda-device $device --port 8188 --listen 127.0.0.1 &
fi

cd /app/image_server

#cd ComfyUI
#if [ -n "$vram_mode" ]
#then
#    python main.py $vram_mode --cuda-device $device --disable-xformers &
#else
#    python main.py --disable-xformers  --cuda-device $device &
#fi
#cd ..

#COMFY_SERVER_PID=$!
#echo "ComfyUI server started with PID: $COMFY_SERVER_PID"
sleep 5

if [ "$warmup" = "true" ]
then
    python warmup.py
else
    sleep 1
fi

uvicorn main:app --host 0.0.0.0 --port $port
#cleanup
