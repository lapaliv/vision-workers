FROM corcelio/vision:image_server-latest as base

RUN mv /app/image_server /app/image_server_old
#COPY --link ./image_server /app/image_server
RUN #mv /app/image_server_old/ComfyUI /app/image_server/
RUN #ln -s /app/image_server /app/server

VOLUME [ "/app/cache", "/app/server" ]

RUN chmod +x /app/server/setup.sh && \
    chmod +x /app/server/entrypoint.sh

RUN apt install -y nano

FROM base as setup
WORKDIR /app

RUN chmod +x /app/server/setup.sh
RUN /usr/bin/bash /app/server/setup.sh

ENTRYPOINT ["tail", "-f", "/dev/null"]

FROM base as app
WORKDIR /app/server

ENTRYPOINT [ "/app/server/entrypoint.sh" ]

FROM base as comfy
WORKDIR /app/server/ComfyUI

RUN #chmod +x /app/server/ComfyUI/entrypoint.sh

ENTRYPOINT [ "/app/server/ComfyUI/entrypoint.sh" ]