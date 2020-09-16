# ubuntu_desktop
### 简介
运行于docker上的ubuntu桌面

* 带有cuda支持（以vistart/cuda为基础镜像）
* 默认为xfce桌面，轻量级桌面，几乎不占用系统资源。
* 支持ssh远程访问（可使用vscode remote）与x2go图形远程访问
* apt和pip已经设置为清华镜像源

支持的版本（Tag）
* 18.04-cu101
* 18.04-cu102
* 20.04-cu101
* 20.04-cu102

### 使用

使用docker运行
```bash
docker run -d --name my_desktop --gpus all  -p 10022:22  gezp/ubuntu18.04-desktop:cu101
```
可ssh访问（vscode remote），或者运行x2go客户端访问GUI桌面。
* 连接端口均为10022（ssh端口）
* 第一次运行需要使用x2go客户端访问GUI桌面进行初始化。（选择default config即可）