# ubuntu_ws_docker
### 1.简介
运行于docker上的ubuntu headless工作空间

* 支持ssh远程访问（可使用vscode + remote ssh插件访问)
* 带有cuda+opengl支持（以nvidia/cudagl为基础镜像）。

gezp/ubuntu_base（Tag）
* 18.04-cu101
* 18.04-cu102
* 20.04-cu101
* 20.04-cu102

gezp/ubuntu_pytorch (Tag)
* 20.04-cu101-torch160
* 18.04-cu101-torch160

### 2.简单使用
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

### 3.高级使用
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
