FROM nvidia/cuda:11.8.0-devel-ubuntu20.04 as base

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

# PM2
RUN set -e; \
    apt-get update && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pm2

# Installing necessary packages
RUN set -e; apt-get update && apt-get install -y wget git

# Installing Miniconda
RUN set -e; \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod 700 Miniconda3-latest-Linux-x86_64.sh \
    && ./Miniconda3-latest-Linux-x86_64.sh -b \
    && rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/root/miniconda3/bin:${PATH}"
RUN set -e; conda create -n venv_image python=3.10.13 -y
ENV PATH="/root/miniconda3/envs/venv_image/bin:${PATH}"

RUN set -e; \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get -y full-upgrade \
    && apt-get -y install python3-dev \
    && apt-get install -y --no-install-recommends \
    build-essential \
    python3-pip\
    apt-utils \
    curl \
    wget \
    vim \
    sudo \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    python3-tk \
    python3-dev \
    git-lfs \
    unzip \
    nano \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -e; apt-get update && apt-get install -y unzip

RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI && \
    cd /app/ComfyUI && \
    git fetch --depth 1 origin f7a5107784cded39f92a4bb7553507575e78edbe && \
    git checkout f7a5107784cded39f92a4bb7553507575e78edbe

COPY image_server/requirements.txt /app/requirements.txt
COPY image_server/entrypoint_comfyui.sh /app/ComfyUI/entrypoint_comfyui.sh

RUN set -e; \
    pip install --upgrade pip \
    && pip install --upgrade pip setuptools==69.5.1 \
    && pip install -r /app/requirements.txt  \
    && pip install huggingface_hub[hf_transfer] \
    && rm -rf /root/.cache/pip/*

COPY --link image_server /app/image_server
COPY image_server/entrypoint_comfyui.sh /app/ComfyUI/entrypoint.sh

ENV APP_HOST=0.0.0.0
ENV APP_PORT=8080
ENV HF_HUB_ENABLE_HF_TRANSFER=1

USER root
ENV DEVICE=0
ENV VRAM_MODE=--normalvram
ENV WARMUP=false

RUN #chmod +x /app/image_server/entrypoint.sh
RUN #chmod +x /app/image_server/setup.sh

RUN set -e; \
    mkdir /app/cache \
    && mkdir /app/cache/hub \
    && chmod -R 777 /app/cache \
    && chmod -R 777 /app/cache/hub

ENV HF_HOME=/app/cache
ENV HF_HUB_CACHE=/app/cache/hub

FROM base as setup
WORKDIR /app

RUN set -e; /usr/bin/bash /app/image_server/setup.sh

ENTRYPOINT ["tail", "-f", "/dev/null"]

FROM base as app
WORKDIR /app/image_server

ENTRYPOINT [ "/app/image_server/entrypoint.sh" ]

FROM base as comfy
WORKDIR /app/ComfyUI

ENTRYPOINT [ "/app/image_server/entrypoint_comfyui.sh" ]