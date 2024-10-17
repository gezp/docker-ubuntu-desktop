

# Ubuntu Desktop based on Docker

[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/r/gezp/ubuntu-desktop)

[简体中文](README_cn.md)

This project provides a docker image which supports ubuntu desktop (xfce4, lightweight, fast and low on system resources), so that you can run virtual ubuntu desktop in container, you can access it by using ssh or remote desktop just like a virtual machine.

Hardware GPU accelerated rendering for 3D GUI application is supported in container, it's based on EGL by using [VirtualGL](https://github.com/VirtualGL/virtualgl), and doesn't require `/tmp/.X11-unix`. if you needn't hardware GPU accelerated rendering, you can also run this container on headless host without GPU (for exmaple, Cloud Server), remote desktop and 3d GUI based on software rendering (high cpu usgae) is also supported.

> Tip: Hardware GPU accelerated rendering is only verified on `ubuntu desktop system` host with `monitor`.  i'm not sure if hardware GPU accelerated rendering can work for  headless `ubuntu server system` host.

## Features

* Remote access by ssh and remote desktop (nomachine or kasmvnc).
* OpenGL rendering based on software rasterizer (LLVMpipe) with high CPU usgae. (default)
* OpenGL rendering based on Nvidia GPU hardware-accelerated.
* Pre-installed Firefox web browser.
* pre-installed CUDA toolkit, which is useful for deep learning, such as pytorch, tensorflow.

> Tip:  it's useful to share public computer resources in labs, you can run a independent computer environment like a virtual machine, but more lightweight, and easier to deploy.
>
> * fast to deploy multiple independent developing environment on a single computer.
> * easy to share files with host or another container.
> * easy to transfer environment to another new computer (save and load image).

xfce4 desktop:

![](img/desktop.png)

## Docker Image Tags:

Supported Tags (you can find here [Github Tag](https://github.com/gezp/docker-ubuntu-desktop/tags))：
* Tags of base image：`18.04`, `20.04`, `22.04`, `24.04`
* Tags of image with cuda (based on `nvidia/cuda`)：`18.04-cu11.0.3`, `20.04-cu11.0.3` etc. 
* naming rules is `{UBUNTU VERSION}-cu{CUDA VERSION}`, you can find supported `{CUDA VERSION}` in [Docker Image <nvidia/cuda>](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/doc/supported-tags.md)

> Supported {CUDA VERSION}:
> * Ubuntu18.04：`11.0.3`, `11.1.1`, `11.2.2`
> * Ubuntu20.04：`11.0.3`, `11.1.0`, `11.2.2`, `11.3.1`, `11.4.3`, `11.5.2`, `11.6.2`, `11.7.1`
> * Ubuntu22.04：`11.7.1`, `11.8.0`, `12.0.1`, `12.1.1`, `12.2.2`, `12.3.2`, `12.4.1`, `12.5.1 `
> * Ubuntu24.04：`12.5.1 `, `12.6.2`

## Preliminary

* install `nvidia driver`
* install `docker` and `nvidia-container-runtime`.

> Tip: the newer cuda version isn't supported if you use older nvidia driver.

## Quickly Start

pull docker image
```bash
docker pull gezp/ubuntu-desktop:20.04-cu11.0.3
# use aliyuncs mirror for chinese users (国内用户可使用阿里云仓库)
# docker pull registry.cn-hongkong.aliyuncs.com/gezp/ubuntu-desktop:20.04-cu11.0.3
```

create conatiner
```bash
# create conatiner with nomachine
docker run -d --restart=on-failure \
    --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all  \
    --shm-size=1024m \
    -e USER=ubuntu \
    -e PASSWORD=ubuntu \
    -e GID=$(id -g) \
    -e UID=$(id -u) \
    -p 10022:22 \
    -p 14000:4000 \
    gezp/ubuntu-desktop:20.04-cu11.0.3

# create conatiner with kasmvnc
docker run -d --restart=on-failure \
    --name my_workspace \
    --gpus all  \
    --shm-size=1024m \
    -e USER=ubuntu \
    -e PASSWORD=ubuntu \
    -e GID=$(id -g) \
    -e UID=$(id -u) \
    -e REMOTE_DESKTOP=kasmvnc \
    -p 10022:22 \
    -p 14000:4000 \
    gezp/ubuntu-desktop:20.04-cu11.0.3
```
* the default username and password are both ubuntu.

access conatiner by ssh
```bash
ssh ubuntu@host-ip -p 10022
```
* it's recommended to use vscode + remote ssh plugin

access conatiner by remote desktop (nomachine)

* download and install [nomachine software](https://www.nomachine.com/).
* the ip is host's ip, the port is 14000.

access conatiner by remote desktop (kasmvnc)

* use browser to access `https://<host-ip>:14000` (chrome is recommended)

Difference between moachine and kasmvnc:

* moachine: need client software to access remote desktop, and support audio, uploads, downloads.
* kasmvnc: provide remote web-based access to desktop, but it doesn't support audio, uploads, downloads, and microphone pass-through.


## Advanced Usage

#### Custom User Argument

configure `REMOTE_DESKTOP`, `VNC_THREADS` when you create conatiner.

* `REMOTE_DESKTOP`: nomachine (default) or kasmvnc.
* `VNC_THREADS`: RectThread num for vncserver, only used when `REMOTE_DESKTOP` = kasmvnc. default is 2, set 0 for auto.

#### Enable GPU hardware-accelerated rendering

#### Test VirtualGL

```bash
vglrun glxinfo | grep -i "opengl"
```

* hardware-accelerated is enable successfully if it's output contain `NVIDIA Product Series`.

you need add prefix  `vglrun`  for command when you run 3D software, for example `vglrun gazebo`.

#### Test vulkan

```bash
# vulkan info
vulkaninfo | grep -i "GPU"
# vulkan demo
vkcube
```

* it's output should contain `NVIDIA Product Series` if vulkan works well.

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
# for 20.04
./docker_build.sh 20.04
# for 20.04-cu11.0.3  (based on nvidia/cuda)
./docker_build.sh 20.04-cu11.0.3
```

## Acknowledgement

thanks to the authors of following related projects:
* https://github.com/selkies-project/docker-nvidia-egl-desktop
* https://github.com/kasmtech/KasmVNC
* https://github.com/VirtualGL/virtualgl
* https://github.com/linuxserver/docker-baseimage-kasmvnc

