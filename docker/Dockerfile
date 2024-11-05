FROM corcelio/vision:image_server-latest as base

RUN git clone https://github.com/lapaliv/vision-workers.git /app/vision-workers && \
    mv /app/image_server /app/image_server_old && \
    mv /app/vision-workers/image_server /app/image_server

VOLUME [ "/app/cache", "/app/image_server/ComfyUI" ]

RUN chmod +x /app/image_server/setup.sh && \
    chmod +x /app/image_server/entrypoint.sh

RUN apt install -y nano

FROM base as preparation
WORKDIR /app
RUN #/usr/bin/bash /app/image_server/setup.sh

RUN sudo apt-get update
RUN sudo apt-get install -y ca-certificates curl
RUN sudo install -m 0755 -d /etc/apt/keyrings
RUN sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN sudo chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update
RUN  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN #docker compose up -d

ENTRYPOINT ["tail", "-f", "/dev/null"]

FROM base as app
ENTRYPOINT [ "/app/image_server/entrypoint.sh" ]

FROM base as comfy
ENTRYPOINT [ "/app/image_server/ComfyUI/entrypoint.sh" ]