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

cd /app/image_server
/usr/bin/bash setup.sh

cd /app/ComfyUI

pip install -r requirements.txt

vram_mode=${VRAM_MODE:-'--lowvram'}
device=${DEVICE:-0}
port=${PORT:-8188}

if [ -n "$vram_mode" ]
then
    python main.py $vram_mode --cuda-device $device --disable-xformers --port $port --listen 127.0.0.1
else
    python main.py --disable-xformers  --cuda-device $device --port $port --listen 127.0.0.1
fi

#cleanup
