# Ubuntu Desktop based on Docker

[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/r/gezp/ubuntu-desktop)

## 1 Introduction
This project provides a docker image that can run the virtual desktop system (xfce4 desktop) in a docker container on the ubuntu headless host, and can use ssh or remote desktop access, you can almost use the container as a virtual machine.

> Note that if you need to use GPU hardware-accelerated OpenGL rendering, the host here needs to install the Ubuntu Desktop system (with its own desktop system, the host is not supported for the Ubuntu Server system), you can use the `HDMI cheat` instead of the display.
> Can run on cloud servers (such as Alibaba Cloud, Tencent Cloud, etc.), but does not support GPU 3D acceleration.

ubuntu-desktop Docker image features:

* Support ssh remote access, support xfce4 remote desktop access.
* Support software simulation OpenGL rendering, can run 3D rendering software (such as gazebo, blender).
* Supports GPU hardware-accelerated OpenGL rendering (requires Nvidia GPU support, and the host must be a desktop system)
* Comes with Chrome browser.
* Comes with CUDA, supports deep learning training (such as pytorch, tensorflow).

> It can be used as a ubuntu virtual development environment, suitable for shared use of public hosts in teaching and research offices. Compared with virtual machines, containers are lightweight (although using containers as virtual machines does not conform to the philosophy of containers: a container runs an app), and its advantages are as follows:
>
> * Start fast (second level).
> * Through the isolation function, multiple containers can be opened to meet the needs of different development environments (avoid conflict of different software packages).
> * Convenient sharing between containers (file sharing, network sharing)
> * Easy migration (export image, environment can be migrated on different hosts).
> * Supports remote desktop and ssh, almost meeting most development needs.

xfce4 (remote) desktop diagram

![](img/desktop.png)

> Realization principle:
>
> Use `nvidia/opengl` as the base image + xfce4 desktop software + nomachine remote desktop software (supporting VirtualGL) to run 3D GUI programs, replace the base image with `nvidia/cudagl`, so as to achieve the ability to support cuda.

Mirror TAG:

The supported image TAGs correspond to [Github Tag](https://github.com/gezp/docker-ubuntu-desktop/tags), with two categories:
* TAG of base image (based on `nvidia/opengl` base image): `18.04`, `20.04`
* TAG of images that support CUDA (based on `nvidia/cudagl` base image): `18.04-cu10.1`, `20.04-cu11.0`, `20.04-cu11.2.0`, etc., the naming rule is `{UBUNTU VERSION` }-cu{CUDA VERSION}`, where cuda version number support list see [Docker Image <nvidia/cudagl>](https://gitlab.com/nvidia/container-images/cudagl/-/blob/DOCS/supported -tags.md)

CUDA version numbers are currently supported:
> * CUDA version numbers supported by Ubuntu18.04: `10.1`, `10.2`, `11.0`, `11.1`, `11.2.0`, `11.3.0`, `11.4.0`
> * CUDA version numbers supported by Ubuntu20.04: `11.0`, `11.1`, `11.2.0`, `11.3.0`, `11.4.0`

## 2. Basic usage

### 2.1 Preparations

* Install nvidia driver
* Install docker and nvidia-container-runtime.

> Pay attention to the nvidia version driver, the old version driver does not support the new version of the cuda container.

### 2.2 Quick use

docker pull: pull the image
```bash
docker pull gezp/ubuntu-desktop:20.04-cu11.0
# Domestic users can use Alibaba Cloud Warehouse
# docker pull registry.cn-hongkong.aliyuncs.com/gezp/ubuntu-desktop:20.04-cu11.0
````

docker run: create and run a container
```bash
# The host needs to run xhost to allow all users to access X11 services (run once), the host environment variable $DISPLAY must be 0
xhost +
# Support ssh and 3D GUI
docker run -d --restart=on-failure \
    --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all \
    --shm-size=1024m \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -p 10022:22 \
    -p 14000:4000 \
    gezp/ubuntu-desktop:20.04-cu11.0
````
* The default username and password are both ubuntu

ssh connection container
```bash
#ssh access container
ssh ubuntu@host-ip -p 10022
````

* Accessible with vscode + remote ssh plugin

Remote Desktop Connection Container

* Download nomachine software, ip is host ip, port is 14000, just connect

## 3. Extension usage

### 3.1 Custom User Parameters

You can use environment variables to customize `USER`, `PASSWORD`, `GID`, `UID` configuration when creating a container, for example:
```bash
docker run -d --restart=on-failure \
    --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all \
    -e USER=cat \
    -e PASSWORD=cat123 \
    -e GID=1001 \
    -e UID=1001 \
    --shm-size=1024m \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -p 10022:22 \
    -p 14000:4000 \
    gezp/ubuntu-desktop:20.04-cu11.0
````

### 3.2 3D hardware rendering acceleration

Test VirtualGL

```bash
vglrun glxinfo | grep -i "opengl"
````

* If the display contains NVIDIA GPU model, it means correct

> DISPLAY on host must be `:0`.

When running 3D software, you need to add the `vglrun` command prefix, such as `vglrun gazebo`.

### 3.3 CUDA Instructions

You need to add the following statement to the `.bashrc` file to update the environment variables
```bash
export CUDA_HOME=/usr/local/cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
````
* For more instructions on using the `nvidia/cuda` Docker image.

## 4. Local image build

E.g
```bash
git clone https://github.com/gezp/docker-ubuntu-desktop.git
cd docker-ubuntu-desktop
# for 20.04 (based on nvidia/opengl base image)
./docker_build.sh 20.04
# for 20.04-cu11.0 (based on nvidia/cudagl base image)
./docker_build.sh 20.04-cu11.0
````
