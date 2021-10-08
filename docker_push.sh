#!/bin/bash

# usage: ./docker_push.sh 20.04-cu11.0

# echo "argv: $1"
UBUNTU_VERSION=`echo $1 | awk -F '-cu' '{print $1}'`
CUDA_VERSION=`echo $1 | awk -F '-cu' '{print $2}'`
echo "ubuntu version:${UBUNTU_VERSION},cuda version:${CUDA_VERSION}"

# check ubuntu version
if [[(${UBUNTU_VERSION} != "18.04") && (${UBUNTU_VERSION} != "20.04")]];then
    echo "Invalid ubuntu version:${UBUNTU_VERSION}"
    exit -1
fi

# #build ubuntu-desktop image
DOCKER_TAG=${UBUNTU_VERSION}-cu${CUDA_VERSION}

# push to docker hub
docker tag ubuntu-desktop:${DOCKER_TAG} gezp/ubuntu-desktop:${DOCKER_TAG}
docker push gezp/ubuntu-desktop:${DOCKER_TAG}
# push to aliyun
docker tag ubuntu-desktop:${DOCKER_TAG} registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:${DOCKER_TAG}
docker push registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:${DOCKER_TAG}

exit 0

