# ubuntu_desktop
### 简介
运行于docker上的ubuntu桌面

* 带有cuda支持（以vistart/cuda为基础镜像）
* 默认为xfce桌面，轻量级桌面，几乎不占用系统资源。
* 支持ssh远程访问（可使用vscode remote）与nomachine图形远程访问
* apt和pip已经设置为清华镜像源

支持的版本（Tag）
* 18.04-cu101
* 18.04-cu102
* 20.04-cu101
* 20.04-cu102

### 使用

使用docker运行
```bash
docker run -d -p 14000:4000 --gpus all --name nomachine --cap-add=SYS_PTRACE gezp gezp/ubuntu18.04-desktop:cu101
```

* 运行nomachine客户端访问GUI桌面: 连接端口均为14000