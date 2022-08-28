#!/bin/bash

# usage: ./docker_push.sh 20.04-cu11.0

DOCKER_TAG=$1

# push to docker hub
docker tag ubuntu-desktop:${DOCKER_TAG} gezp/ubuntu-desktop:${DOCKER_TAG}
docker push gezp/ubuntu-desktop:${DOCKER_TAG}
# push to aliyun
docker tag ubuntu-desktop:${DOCKER_TAG} registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:${DOCKER_TAG}
docker push registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:${DOCKER_TAG}

exit 0

