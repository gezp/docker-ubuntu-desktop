# Ubuntu Desktop based on Docker

[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/r/gezp/ubuntu-desktop)

[简体中文](README_cn.md)

This project provides a docker image which supports ubuntu desktop (xfce4, lightweight, fast and low on system resources), so that you can run virtual ubuntu desktop in container, you can access it by using ssh or remote desktop just like a virtual machine.

Hardware GPU accelerated rendering for 3D GUI application is supported in container, but it's based on the host's rendering capability, so 
the host must be a `ubuntu desktop system` with `monitor`  (you can use `HDMI dummy plug` instead of monitor), Nvidia GPU and driver need also be installed on the host.

> Tip: if you needn't hardware GPU accelerated rendering, you can also run this container based on this image on headless host (like Cloud Server),
remote desktop and 3d GUI based on software rendering (high cpu usgae) is also supported.

## Features

* Remote access by ssh and nomachine(remote desktop).
* OpenGL rendering based on software rasterizer (LLVMpipe) with high CPU usgae.
* OpenGL rendering based on Nvidia GPU hardware-accelerated (requires Nvidia GPU support, and the host must be a desktop system).
* Pre-installed chrome browser.
* pre-installed CUDA toolkit, which is useful for deep learning (such as pytorch, tensorflow).

> Tip:  it's useful to share public computer resources in labs, you can run a independent computer environment like a virtual machine, but more lightweight, and easier to deploy.
>
> * fast to deploy multiple independent developing environment on a single computer.
> * easy to share files with host or another container.
> * easy to transfer environment to another new computer (save and load image).

xfce4 desktop:

![](img/desktop.png)

## Docker Image Tags:

Supported Tags (you can find here [Github Tag](https://github.com/gezp/docker-ubuntu-desktop/tags))：
* Tags of base image (based on `nvidia/opengl`)：`18.04`, `20.04`
* Tags of image with cuda(based on `nvidia/cudagl`)：`18.04-cu10.1`, `20.04-cu11.0` etc. 
* naming rules is `{UBUNTU VERSION}-cu{CUDA VERSION}`, you can find supported `{CUDA VERSION}` in [Docker Image <nvidia/cudagl>](https://gitlab.com/nvidia/container-images/cudagl/-/blob/DOCS/supported-tags.md)

> Supported {CUDA VERSION}:
> * Ubuntu18.04：`10.1`, `10.2`, `11.0`, `11.1`, `11.2.0`, `11.3.0`, `11.4.0`
> * Ubuntu20.04：`11.0`, `11.1`, `11.2.0`, `11.3.0`, `11.4.0`

## Preliminary

* install `nvidia driver`
* install `docker` and `nvidia-container-runtime`.

xhost
```bash
# enable all users to access X11 service on host machine (run once).
xhost +
# check DISPLAY setting, $DISPLAY must be 0
echo $DISPLAY
# check host rendering setting, the host must use nvidia GPU for opengl
sudo apt install mesa-utils
# it's output contain must `NVIDIA Product Series`.
glxinfo | grep -i "opengl"
```

> Tip: the newer cuda version isn't supported if you use older nvidia driver.

## Quickly Start

pull docker image
```bash
docker pull gezp/ubuntu-desktop:20.04-cu11.0
# use aliyuncs mirror for chinese users (国内用户可使用阿里云仓库)
# docker pull registry.cn-hongkong.aliyuncs.com/gezp/ubuntu-desktop:20.04-cu11.0
```

create conatiner
```bash
# create conatiner
docker run -d --restart=on-failure \
    --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all  \
    --shm-size=1024m \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -p 10022:22  \
    -p 14000:4000  \
    gezp/ubuntu-desktop:20.04-cu11.0
```
* the default username and password are both ubuntu.

access conatiner by ssh
```bash
ssh ubuntu@host-ip -p 10022
```
* it's recommended to use vscode + remote ssh plugin

access conatiner by nomachine client (remote desktop)

* download and install [nomachine software](https://www.nomachine.com/).
* the ip is host's ip, the port is 14000.

## Advanced Usage

#### Custom User Argument

configure `USER`, `PASSWORD`, `GID`, `UID` when you create conatiner，for example：
```bash
docker run -d --restart=on-failure \
    --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all  \
    -e USER=cat \
    -e PASSWORD=cat123 \
    -e GID=1001 \
    -e UID=1001 \
    --shm-size=1024m \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -p 10022:22  \
    -p 14000:4000  \
    gezp/ubuntu-desktop:20.04-cu11.0
```

#### Enable GPU hardware-accelerated rendering

test VirtualGL

```bash
vglrun glxinfo | grep -i "opengl"
```

* hardware-accelerated is enable successfully if it's output contain `NVIDIA Product Series`.

> environment variable `$DISPLAY` on host must be `:0` .

you need add prefix  `vglrun`  for command when you run 3D software, for example `vglrun gazebo`.

#### CUDA

add shell in `.bashrc` to update environment variable
```bash
export CUDA_HOME=/usr/local/cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```
* for detailed usage, you can refer to `nvidia/cuda` Docker Image.

## Build

for example
```bash
git clone https://github.com/gezp/docker-ubuntu-desktop.git
cd docker-ubuntu-desktop
# for 20.04 (based on nvidia/opengl)
./docker_build.sh 20.04
# for 20.04-cu11.0  (based on nvidia/cudagl)
./docker_build.sh 20.04-cu11.0
```
