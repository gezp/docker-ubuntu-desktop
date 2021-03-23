# Ubuntu Desktop based on Docker

[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/r/gezp/ubuntu-desktop) 

## 1.简介
基于docker运行于ubuntu headless主机上的的虚拟桌面系统，你几乎可以把它当作虚拟机使用，可以使用远程桌面访问，它可以当作ubuntu虚拟开发环境使用，作为日常的开发环境（适合教研室公共主机共享使用），特别的，它支持nvidia GPU加速，支持深度学习训练以及3D GUI程序的运行。


目前市面上的docker的桌面系统方案，大部分不支持3D软件，就算支持配置步骤也相当繁琐，违背了日常开发可以方便更换虚拟机的需求求。所以这个项目就诞生了，该解决方案支持3D软件和远程桌面，几乎满足大部分开发需求（service软件除外），而且使用也方便。

> 相比虚拟机，容器是轻量级的，虽然把容器当作虚拟使用，原则上是不合理的，但是在某些情况，使用真机开发或者虚拟机开发会经常出现一些问题：
> 
> * 经常将开发环境搞崩，需要重新配置环境，费时费力。
> * 需要进行多个项目，两个项目之间的软件包版本冲突，不能在一个真机上搞。
> * 很多时候用到虚拟机是杀鸡用牛刀，虚拟机既能运行win,又能运行linux,但我们想要的只是在ubuntu系统上运行ubuntu虚拟机，只需要隔离功能而已。
> * 虚拟机配置麻烦，启动也慢，运行OS之上的虚拟机对GPU支持差。

ubuntu-desktop特性：

* 支持ssh远程访问，支持xfce4远程桌面访问
* 自带cuda,支持深度学习训练（如pytorch,tensorflow）
* 支持GPU 硬件3D加速，可运行3D渲染软件（如gazebo,blender）

> 实现方法：
>
> * nvidia/cudagl-devel为基础镜像 +  nomachine远程桌面软件（支持VirtualGL）。

## 2.基本使用

### 2.1 准备工作

* 安装nvidia驱动
* 安装docker和nvidia-container-runtime.

> 注意nvidia版本驱动，过老的版本驱动不支持新版本的cuda.(容器自带cuda)

### 2.2 创建容器

**Create container**

```bash
#宿主机需要运行xhost允许所有用户访问X11服务（运行一次即可）
xhost +
#支持ssh和GUI，#DISPLAY需要和host一致
docker run -d --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all  \
    --shm-size=1024m \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -p 10022:22  \
    -p 14000:4000  \
    gezp/ubuntu-desktop:20.04-cu110
```

> 支持Tag:  18.04-cu101，18.04-cu102，20.04-cu110，20.04-cu111

### 2.3 ssh连接容器

```bash
#ssh访问容器
ssh ubuntu@host-ip -p 10022
```

* 用户名和密码均为ubuntu
* 可使用vscode + remote ssh插件访问

### 2.4 远程桌面连接容器

* 下载nomachine软件，ip为主机ip，端口为14000，进行连接即可

## 3. 3D硬件加速

测试VirtualGL

```bash
sudo /etc/NX/nxserver --virtualgl-install
sudo /etc/NX/nxserver --virtualgl yes
/usr/NX/scripts/vgl/vglrun glxinfo | grep -i "opengl"
```

* 显示包含VirtualGL则表示正确

> host主机上的DISPLAY必须为`:0` .

运行3D软件时，需要加上`/usr/NX/scripts/vgl/vglrun` 命令前缀。

