#!/bin/bash

# usage: build_and_push.sh 20.04-cu11.0

# echo "argv: $1"
UBUNTU_VERSION=`echo $1 | awk -F '-cu' '{print $1}'`
CUDA_VERSION=`echo $1 | awk -F '-cu' '{print $2}'`

# check ubuntu version
if [[(${UBUNTU_VERSION} != "18.04") && (${UBUNTU_VERSION} != "20.04")]];then
    echo "Invalid ubuntu version:${UBUNTU_VERSION}"
    exit -1
fi

# pull cudagl docker image
CUDAGL_TAG=${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
docker pull nvidia/cudagl:${CUDAGL_TAG}
if [[ $? != 0 ]]; then 
    echo "Failed to pull docker image 'nvidia/cudagl:${CUDAGL_TAG}'"
    exit -2
fi

# #build ubuntu-desktop image
DOCKER_TAG = ${UBUNTU_VERSION}-cu${CUDA_VERSION}
docker build ubuntu-desktop/${UBUNTU_VERSION} --file ubuntu-desktop/${UBUNTU_VERSION}/Dockerfile  \
             --build-arg CUDAGL_TAG=${CUDAGL_TAG} \
             --tag ubuntu-desktop:${DOCKER_TAG}
if [[ $? != 0 ]]; then 
    echo "Failed to build docker image 'ubuntu-desktop:${DOCKER_TAG}'"
    exit -3
fi
# push to docker hub
docker tag ubuntu-desktop:${DOCKER_TAG} gezp/ubuntu-desktop:${DOCKER_TAG}
docker push gezp/ubuntu-desktop:${DOCKER_TAG}
# push to aliyun
docker tag ubuntu-desktop:${DOCKER_TAG} registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:${DOCKER_TAG}
docker push registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:${DOCKER_TAG}

exit 0

