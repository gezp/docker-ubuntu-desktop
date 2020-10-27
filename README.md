# ubuntu_ws_docker
### 1.简介
运行于docker上的ubuntu headless工作空间

* 带有cuda+opengl支持（以nvidia/cudagl-devel为基础镜像）。
* gezp/ubuntu_base支持ssh远程访问（可使用vscode + remote ssh插件访问)
* gezp/ubuntu_machine支持桌面容器（支持virtualGL运行3D GUI程序）

| Repo                  | Tag                                                        | 说明                        |
| --------------------- | ---------------------------------------------------------- | --------------------------- |
| gezp/ubuntu_base      | 18.04-cu101<br>18.04-cu102<br/>20.04-cu110<br/>20.04-cu111 | cuda+opengl+ssh             |
| gezp/ubuntu_nomachine | 18.04-cu101<br/>20.04-cu110                                | ubuntu_base+nomachine+xfce4 |
| gezp/ubuntu_pytorch   | 18.04-cu101-torch160 <br/>20.04-cu110-torch160             | ubuntu_base+pytorch         |

* username: ubuntu,    password: ubuntu.

### 2.ubuntu_base使用

#### 2.1.ssh使用

该方式支持ssh访问容器

**运行docker** 

```bash
docker run -d --name my_workspace --gpus all  -p 10022:22  gezp/ubuntu_base:18.04-cu101
```

**访问容器**

```bash
#docker命令访问容器
docker exec -it my_workspace bash
#ssh访问容器
ssh ubuntu@ip -p 10022
```

* 用户名和密码均为ubuntu

#### 2.2 GUI使用
该方式支持运行GUI程序在宿主(host)桌面上

**运行docker**

```bash
#宿主机需要运行xhost允许所有用户访问X11服务
xhost +
#支持ssh和GUI，#DISPLAY需要和host一致
docker run -d --name my_workspace \
	--gpus all \
    -e DISPLAY=$DISPLAY \
    --device=/dev/dri:/dev/dri \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -p 10022:22 \
    gezp/ubuntu_base:18.04-cu101
```

**运行GUI程序** 

首先使用docker命令或者ssh访问容器

```bash
#docker命令访问容器
docker exec -it my_workspace bash
#ssh访问容器
ssh ubuntu@ip -p 10022
export DISPLAY=:0  #DISPLAY需要和host一致
```

* 然后容器内运行gedit命令，可以看见在宿主机打开了一个记事本。
* 支持3D GUI应用程序，如blender,gazebo等。

### 3.ubuntu_pytorch使用

* 同ubuntu_base

### 4.ubuntu_nomachine使用

在docker中运行xfce4 desktop环境，并使用nomachine远程访问，支持VirtualGL运行3D程序

```bash
docker run -d --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all  \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -p 10022:22  \
    -p 14000:4000  \
    gezp/ubuntu_desktop:20.04-cu110
```

* ssh端口为10022，nomachine端口为14000

测试VirtualGL

```bash
sudo /etc/NX/nxserver --virtualgl-install
sudo /etc/NX/nxserver --virtualgl yes
/usr/NX/scripts/vgl/vglrun glxinfo | grep -i "opengl"
```

* 显示包含VirtualGL则表示正确

> host主机上的DISPLAY必须为`:0` .