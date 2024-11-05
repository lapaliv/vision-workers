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
RUN /usr/bin/bash /app/image_server/setup.sh && \
    docker compose up -d

ENTRYPOINT ["tail", "-f", "/dev/null"]

FROM base as app
ENTRYPOINT [ "/app/image_server/entrypoint.sh" ]

FROM base as comfy
ENTRYPOINT [ "/app/image_server/ComfyUI/entrypoint.sh" ]