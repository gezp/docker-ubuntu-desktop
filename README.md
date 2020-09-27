# ubuntu_desktop
### 简介
运行于docker上的ubuntu桌面

* 带有cuda支持（以vistart/cuda为基础镜像）
* 默认为xfce桌面，轻量级桌面，几乎不占用系统资源。
* 支持ssh远程访问（可使用vscode remote）与nomachine图形远程访问
* apt和pip已经设置为清华镜像源，支持中文。

基本图形桌面版本（Tag）
* 18.04-cu101
* 18.04-cu102
* 20.04-cu101
* 20.04-cu102

增强版本(Tag)
* 20.04-cu101-torch160
* 20.04-cu101-ros2-foxy

### 使用

使用docker运行
```bash
docker run -d -p 14000:4000 -p 10022:22 --gpus all --name nomachine --cap-add=SYS_PTRACE gezp/ubuntu-desktop:20.04-cu101
```

* nomachine客户端访问GUI桌面: 连接端口为14000
* ssh远程访问（可使用vscode remote）：连接端口为10022