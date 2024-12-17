#!/bin/bash

docker buildx create --name raspibuilder
docker buildx use raspibuilder
docker buildx build --platform linux/arm64,linux/x86_64 -t fwinkler79/arm64-docker-client:1.0.0 --push .