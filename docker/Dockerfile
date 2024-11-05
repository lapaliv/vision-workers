FROM corcelio/vision:image_server-latest as base

RUN git clone https://github.com/lapaliv/vision-workers.git /app/vision-workers && \
    mv /app/image_server /app/image_server_old && \
    mv /app/vision-workers/image_server /app/image_server

RUN mv /app/image_server /app/image_server_old

COPY --link ./image_server /app/image_server

VOLUME [ "/app/cache", "/app/image_server/ComfyUI" ]

RUN chmod +x /app/image_server/setup.sh && \
    chmod +x /app/image_server/entrypoint.sh

RUN apt install -y nano

FROM base as setup
WORKDIR /app
RUN /usr/bin/bash /app/image_server/setup.sh

RUN chmod +x /app/images_server/setup.sh

ENTRYPOINT ["tail", "-f", "/dev/null"]

FROM base as app
WORKDIR /app/image_server

COPY ./wait-for-setup.sh /wait-for-setup.sh
RUN chmod +x /wait-for-setup.sh

ENTRYPOINT [ "/app/image_server/entrypoint.sh" ]

FROM base as comfy
WORKDIR /app/image_server/ComfyUI

COPY ./wait-for-setup.sh /wait-for-setup.sh
RUN chmod +x /wait-for-setup.sh

ENTRYPOINT [ "/app/image_server/ComfyUI/entrypoint.sh" ]