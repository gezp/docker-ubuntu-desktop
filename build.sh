cuda_version=11.0
#build for ubuntu20.04
docker build ubuntu-desktop/18.04 --file ubuntu-desktop/18.04/Dockerfile  \
             --build-arg CUDAGL_VERSION=${cuda_version}-devel-18.04 \
             --tag ubuntu-desktop:18.04-cu${cuda_version}
#build for ubuntu20.04
docker build ubuntu-desktop/20.04 --file ubuntu-desktop/20.04/Dockerfile  \
             --build-arg CUDAGL_VERSION=${cuda_version}-devel-ubuntu20.04 \
             --tag ubuntu-desktop:20.04-cu${cuda_version}