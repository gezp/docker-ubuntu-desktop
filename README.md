# Ubuntu Desktop based on Docker
## 1.简介
基于docker实现，运行于ubuntu headless主机上的的虚拟桌面系统，你几乎可以把它当作虚拟机使用，可以使用远程桌面访问，特别的，支持nvidia GPU加速。

特性：

* 支持ssh远程访问，支持xfce4远程桌面访问
* 自带Cuda,支持深度学习训练（如pytorch,tensorflow）
* 支持GPU 硬件3D加速，可运行3D渲染软件（如gazebo,blender）

> 实现方法：
>
> * nvidia/cudagl-devel为基础镜像 +  nomachine远程桌面软件（支持VirtualGL）。

## 2.基本使用

### 2.1 创建容器

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
    gezp/ubuntu-base:20.04-cu110
```

> 支持Tag:  18.04-cu101，18.04-cu102，20.04-cu110，20.04-cu111

### 2.2 ssh连接容器

```bash
#ssh访问容器
ssh ubuntu@host-ip -p 10022
```

* 用户名和密码均为ubuntu
* 可使用vscode + remote ssh插件访问

### 2.3.远程桌面连接容器

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

