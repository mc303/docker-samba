#!/bin/sh
#env DOCKER_BUILDKIT=1 docker build --no-cache -t mc303/samba .
env DOCKER_BUILDKIT=1

BUILDENV=buildsamba

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

#create platform buildx env
docker buildx create --platform linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 --name $BUILDENV --driver docker-container
docker buildx use $BUILDENV

# build platforms
docker buildx build --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 -t ghcr.io/mc303/samba --push .
#docker buildx build --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 -t ghcr.io/mc303/samba  .

# remove build env
docker buildx rm $BUILDENV
