#!/usr/bin/env bash

### test build

CONTAINER_NAME="ghcr.io/mc303/samba:latest"
BUIILDX_REPO='build-samba'
BUILD_PLATFORM="linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64"

echo ${CONTAINER_NAME}
echo ${BUIILDX_REPO}
echo ${BUILD_PLATFORM}

echo "docker buildx build . --platform=${BUILD_PLATFORM} --tag ${CONTAINER_NAME} --push"

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

#create multiplatform environment
docker buildx create --platform=${BUILD_PLATFORM} --name ${BUIILDX_REPO}
docker buildx use ${BUIILDX_REPO}

#build multiplatform docker image
docker buildx build . --platform=${BUILD_PLATFORM} --tag ${CONTAINER_NAME} --push

#remove multiplatform environment
docker buildx rm ${BUIILDX_REPO}
