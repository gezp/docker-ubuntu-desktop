# Ubuntu Desktop based on Docker

[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/r/gezp/ubuntu-desktop) 

## 1.简介
该项目提供了一个docker镜像，可以将虚拟桌面系统（xfce4桌面）运行于ubuntu headless主机上的docker容器中，并且可以使用ssh或远程桌面访问，你几乎可以把容器当作虚拟机使用。

> 对于ubuntu headless服务器（无外接显示器），需要使用`HDMI欺骗器`,淘宝也就3元左右。

ubuntu-desktop docker镜像特性：

* 支持ssh远程访问，支持xfce4远程桌面访问
* 自带cuda，支持深度学习训练（如pytorch,tensorflow）
* 支持GPU 硬件3D加速，可运行3D渲染软件（如gazebo,blender）


> 它可以当作ubuntu虚拟开发环境使用，适合教研室公共主机共享使用。相比虚拟机，容器是轻量级的（虽然把容器当作虚拟使用不符合容器的哲学：一个容器运行一个APP），其优点如下：
>
> * 启动快（秒级别）。
> * 通过隔离功能，开启多个容器，满足不同开发环境需求（避免不同软件包版本冲突）。
> * 容器之间可以方便进行共享（文件共享，网络共享）
> * 迁移方便（导出镜像，可在不同主机上迁移环境）。
> * 支持远程桌面与ssh，几乎满足大部分开发需求。

xfce4（远程）桌面示意图

![](img/desktop.png)

* 使用nomachine客户端连接docker容器的远程桌面。
* 支持Chrome浏览器使用。
* 支持Blender使用GPU硬件加速的OpenGL渲染，而不是软件模拟的OpenGL渲染。

> 实现方法：
>
> * nvidia/cudagl-devel为基础镜像 +  nomachine远程桌面软件（支持VirtualGL）。

支持的镜像TAG (对应[Github Tag](https://github.com/gezp/docker-ubuntu-desktop/tags))
* ubuntu18.04系列：`18.04-cu10.1`,`18.04-cu10.2`,`18.04-cu11.0`,`18.04-cu11.1`等
* ubuntu20.04系列：`20.04-cu11.0`,`20.04-cu11.1`等


## 2.基本使用

### 2.1 准备工作

* 安装nvidia驱动
* 安装docker和nvidia-container-runtime.

> 注意nvidia版本驱动，过老的版本驱动不支持新版本的cuda.(容器自带cuda)

### 2.2 创建容器

docker pull: 国内用户可使用阿里云仓库
```bash
docker pull registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:20.04-cu11.0
#重命名镜像
docker image tag registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:20.04-cu11.0 gezp/ubuntu-desktop:20.04-cu11.0
docker rmi registry.cn-shenzhen.aliyuncs.com/gezp/ubuntu-desktop:20.04-cu11.0
```
docker run: 创建并运行容器
```bash
#宿主机需要运行xhost允许所有用户访问X11服务（运行一次即可）,宿主机环境变量$DISPLAY必须为0
xhost +
#支持ssh和GUI
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


### 2.3 连接容器

ssh连接
```bash
#ssh访问容器
ssh ubuntu@host-ip -p 10022
```

* 用户名和密码均为ubuntu
* 可使用vscode + remote ssh插件访问

远程桌面连接

* 下载nomachine软件，ip为主机ip，端口为14000，进行连接即可

### 2.4 3D硬件渲染加速

测试VirtualGL

```bash
vglrun glxinfo | grep -i "opengl"
```

* 显示包含VirtualGL则表示正确

> host主机上的DISPLAY必须为`:0` .

运行3D软件时，需要加上`vglrun` 命令前缀，如`vglrun gazebo`。


## 3. 本地镜像构建

例如
```bash
git clone https://github.com/gezp/docker-ubuntu-desktop.git
cd docker-ubuntu-desktop
# for 20.04-cu11.0
./docker_build.sh 20.04-cu11.0
```
