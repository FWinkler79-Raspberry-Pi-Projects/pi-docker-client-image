# pi-docker-client-image

- [Contents](#contents)
- [Building](#building)
- [Running](#running)
- [References](#references)

## Contents

A docker image for Raspberry Pi with the Docker client installed.

This can be useful, if you want to run the docker client from a container, or if you want to remote-control the host's docker daemon from within the container itself.

You can find a built image here: [fwinkler79/arm64v8-docker-client:1.0.0](https://hub.docker.com/repository/docker/fwinkler79/arm64v8-docker-client/general)

## Building

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

With the `--platform` parameter you set the platform you want to build the image for. You can find out about the list of target architectures docker supports, by executing `docker buildx inspect raspibuilder`. This will yield output like this:

```shell
Name:          raspibuilder
Driver:        docker-container
Last Activity: 2024-12-17 22:18:26 +0000 UTC

Nodes:
Name:                  raspibuilder0
Endpoint:              desktop-linux
Status:                running
BuildKit daemon flags: --allow-insecure-entitlement=network.host
BuildKit version:      v0.18.2
Platforms:             linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
Labels:
# [...]
```
Here you can see all platforms the builder supports.

Note that your `Dockerfile` that you build using `docker buildx build --platform linux/arm64 -t <docker-user-name>/<image-name>:<version> --push .` needs to be based on an image that supports the target platform you specify. For example, if you specify platform `linux/amd64` but your `Dockerfile` starts `FROM` an `arm64v8/alpine`, the build will fail, since the base image is only available for the `arm64v8` platform.

💡 Note: You can specify multiple platforms to build a "fat image" that can be used on multiple platforms. You specify the platforms by separating them with commas like this:

```shell
docker buildx build --platform linux/arm64,linux/amd64 -t <docker-user-name>/<image-name>:<version> --push .
```

However, also in this case your `Dockerfile`'s base image needs to support all the specified platforms, otherwise the build will fail.

## Running

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

## References

* [Cross-Building Docker Images](https://fwinkler79.github.io/blog/cross-building-docker-images.html)
* [Docker Multi-Arch Builds and Cross Builds](https://docs.docker.com/docker-for-mac/multi-arch/)
* [arm32v7 Docker Images](https://hub.docker.com/u/arm32v7)
* [arm64v8 Docker Images](https://hub.docker.com/u/arm64v8)
* [Docker Official Images](https://github.com/docker-library/official-images?tab=readme-ov-file#architectures-other-than-amd64)
* [Docker Official Alpine arm64v8 Image](https://hub.docker.com/r/arm64v8/alpine)
* [Alpine Official arm64v8 image](https://hub.docker.com/layers/library/alpine/latest/images/sha256-cf7e6d447a6bdf4d1ab120c418c7fd9bdbb9c4e838554fda3ed988592ba02936)


