FROM arm64v8/alpine:latest

ARG DOCKER_CLI_VERSION="27.4.0"
ENV DOWNLOAD_URL="https://download.docker.com/linux/static/stable/aarch64/docker-$DOCKER_CLI_VERSION.tgz"

# install docker client
RUN apk --update add curl \
    && mkdir -p /tmp/download \
    && curl -L $DOWNLOAD_URL | tar -xz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && rm -rf /tmp/download \
    && apk del curl \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["docker"]
CMD ["-v"]
