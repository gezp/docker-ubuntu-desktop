# Ubuntu Desktop based on Docker

[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/r/gezp/ubuntu-desktop) 

该项目提供了一个docker镜像，可以将虚拟桌面系统（xfce4桌面）运行于ubuntu headless主机上的docker容器中，并且可以使用ssh或远程桌面访问，你几乎可以把容器当作虚拟机使用。


## 1.特点

* 支持ssh远程访问，支持xfce4远程桌面访问。
* 支持软件模拟的OpenGL渲染，可运行3D渲染软件 (如gazebo, blender)。
* 支持GPU硬件加速的OpenGL渲染（需要Nvidia GPU支持）。
* 自带Firefox浏览器。
* 自带CUDA, 支持深度学习训练 (如pytorch, tensorflow)。

> 它可以当作ubuntu虚拟开发环境使用，适合教研室公共主机共享使用。相比虚拟机，容器是轻量级的（虽然把容器当作虚拟使用不符合容器的哲学：一个容器运行一个APP），其优点如下：
>
> * 通过隔离功能，可以在一台主机上快速部署多个不同开发环境
> * 容器之间可以方便进行共享（文件共享，网络共享）
> * 迁移方便（导出镜像，可在不同主机上迁移环境）

xfce4（远程）桌面示意图

![](img/desktop.png)

镜像TAG:

支持的镜像TAG对应[Github Tag](https://github.com/gezp/docker-ubuntu-desktop/tags)，具有两类：
* 基本镜像的TAG：`18.04`, `20.04`, `22.04`, `24.04`
* 支持CUDA的镜像(基于`nvidia/cuda`基础镜像)的TAG：`18.04-cu11.0.3`, `20.04-cu11.0.3`等, 命名规则为`{UBUNTU VERSION}-cu{CUDA VERSION}`, 其中cuda的版本号支持列表见[Docker Image <nvidia/cuda>](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/doc/supported-tags.md)

>目前支持CUDA版本号：
> * Ubuntu18.04：`11.0.3`, `11.1.1`, `11.2.2`
> * Ubuntu20.04：`11.0.3`, `11.1.0`, `11.2.2`, `11.3.1`, `11.4.3`, `11.5.2`, `11.6.2`, `11.7.1`
> * Ubuntu22.04：`11.7.1`, `11.8.0`, `12.0.1`, `12.1.1`, `12.2.2`, `12.3.2`, `12.4.1`, `12.5.1 `
> * Ubuntu24.04：`12.5.1 `, `12.6.2`

## 2.基本使用

### 2.1 准备工作

* 安装nvidia驱动
* 安装docker和nvidia-container-runtime.

> 注意nvidia版本驱动，过老的版本驱动不支持新版本的cuda容器.

### 2.2 快速使用

docker pull: 拉取镜像
```bash
docker pull gezp/ubuntu-desktop:20.04-cu11.0.3
# 国内用户可使用阿里云仓库
# docker pull registry.cn-hongkong.aliyuncs.com/gezp/ubuntu-desktop:20.04-cu11.0.3
```

docker run: 创建并运行容器
```bash
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

# create conatiner with kasmvnc/novnc
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
* 默认用户名和密码均为ubuntu

ssh连接容器
```bash
#ssh访问容器
ssh ubuntu@host-ip -p 10022
```

* 可使用vscode + remote ssh插件访问

访问远程桌面 (nomachine方式)

* 下载安装[nomachine software](https://www.nomachine.com/).
* ip为主机ip，端口为14000，进行连接即可

访问远程桌面 (kasmvnc/novnc方式)

* 使用浏览器访问 `https://<host-ip>:14000` (推荐chrome)

## 3.扩展使用

### 3.1 自定义用户参数

在创建容器时可使用环境变量自定义`REMOTE_DESKTOP`, `VNC_THREADS`配置

* `REMOTE_DESKTOP`: nomachine (default) , kasmvnc, novnc.
* `VNC_THREADS`: 仅当 `REMOTE_DESKTOP` = kasmvnc时有效，用于设置vncserver的RectThread num. 默认是2, 设置0表示自动选择.

### 3.2 3D硬件渲染加速

测试VirtualGL

```bash
vglrun glxinfo | grep -i "opengl"
```

* 显示包含NVIDIA GPU型号，则表示正确

运行3D软件时，需要加上`vglrun`命令前缀，如`vglrun gazebo`。

### 3.3 CUDA使用说明

需要在`.bashrc`文件中加入以下语句更新环境变量
```bash
export CUDA_HOME=/usr/local/cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```
* 更多使用参考`nvidia/cuda`Docker镜像的说明。

## 4. 本地镜像构建

例如
```bash
git clone https://github.com/gezp/docker-ubuntu-desktop.git
cd docker-ubuntu-desktop
# for 20.04
./docker_build.sh 20.04
# for 20.04-cu11.0.3  (based on nvidia/cuda)
./docker_build.sh 20.04-cu11.0.3
```
