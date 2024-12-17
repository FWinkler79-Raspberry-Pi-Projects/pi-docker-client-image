# pi-docker-client-image

A docker image for Raspberry Pi with the Docker client installed.

This can be useful, if you want to run the docker client from a container, or if you want to remote-control the host's docker daemon from within the container itself.

You can find a built image here: [fwinkler79/arm64v8-docker-client:1.0.0](https://hub.docker.com/repository/docker/fwinkler79/arm64v8-docker-client/general)

# Building

You can build the image on Raspberrry Pi itself, if you like, using:

```bash
docker build .
```

However, you can build this image on your Mac or Linux machine, if you want to, using docker's cross-build feature:

```bash
# Listing existing docker buildx builders. You can see which architectures are supported.
docker buildx ls

# Create docker buildx builder named 'raspibuilder'
docker buildx create --name raspibuilder

# Use 'raspibuilder' for docker buildx
docker buildx use raspibuilder

# Cross-building Docker image for Raspi
docker buildx build --platform linux/arm64 -t <docker-user-name>/<image-name>:<version> --push .
```
# Running

To run the image on Raspberry Pi, simply execute:

```bash
# This simply prints the Docker client version:
docker run -it <docker-user-name>/<image-name>:<version>

# Output:
Docker version 27.4.0, build 831ebea
```

To execute more useful commands and interact with the host's Docker daemon, you need to make the `/var/run/docker.sock` into the container:

```bash
# This calls `docker container ls` from within the container using the host's daemon to list the host's running containers
docker run -it -v /var/run/docker.sock:/var/run/docker.sock <docker-user-name>/<image-name>:<version> container ls

# Output (similar to this):
CONTAINER ID   IMAGE                                             COMMAND                 CREATED          STATUS                  PORTS     NAMES
6cc3ec49fa78   fwinkler79/arm64v8-docker-client:1.0.0            "docker container ls"   2 seconds ago    Up Less than a second             docky
```





