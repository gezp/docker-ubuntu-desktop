Ubuntu Desktop based on Docker
DockerHub

1 Introduction
This project provides a docker image that can run the virtual desktop system (xfce4 desktop) in a docker container on the ubuntu headless host, and can use ssh or remote desktop access, you can almost use the container as a virtual machine.

Note that if you need to use GPU hardware-accelerated OpenGL rendering, the host here needs to install the Ubuntu Desktop system (with its own desktop system, the host is not supported by the Ubuntu Server system), you can use the HDMI cheater instead of the display. It can run on cloud servers (such as Alibaba Cloud, Tencent Cloud, etc.), but does not support GPU 3D acceleration.

ubuntu-desktop Docker image features:

Support ssh remote access, support xfce4 remote desktop access.
It supports OpenGL rendering for software simulation, and can run 3D rendering software (such as gazebo, blender).
Supports GPU hardware-accelerated OpenGL rendering (requires Nvidia GPU support, and the host must be a desktop system)
Comes with Chrome browser.
Comes with CUDA, supports deep learning training (such as pytorch, tensorflow).
It can be used as a ubuntu virtual development environment, suitable for shared use of public hosts in teaching and research offices. Compared with virtual machines, containers are lightweight (although using containers as virtual machines does not conform to the philosophy of containers: a container runs an app), and its advantages are as follows:

Start fast (second level).
Through the isolation function, multiple containers can be opened to meet the needs of different development environments (to avoid conflicting versions of different software packages).
Convenient sharing between containers (file sharing, network sharing)
Easy to migrate (export images to migrate environments on different hosts).
Support remote desktop and ssh, almost meet most development needs.
xfce4 (remote) desktop diagram



Implementation principle:

Use nvidia/opengl as the base image + xfce4 desktop software + nomachine remote desktop software (supporting VirtualGL) to run 3D GUI programs, replace the base image with nvidia/cudagl, so as to achieve the ability to support cuda.

Mirror TAG:

The supported mirror tags correspond to Github tags, and there are two types:

Base image (based on nvidia/opengl base image) TAG: 18.04, 20.04
TAGs of images that support CUDA (based on nvidia/cudagl base images): 18.04-cu10.1, 20.04-cu11.0, 20.04-cu11.2.0, etc., the naming rules are {UBUNTU VERSION}-cu{CUDA VERSION}, where cuda See Docker Image <nvidia/cudagl> for a list of supported version numbers
Currently supported CUDA version numbers:

CUDA version numbers supported by Ubuntu18.04: 10.1, 10.2, 11.0, 11.1, 11.2.0, 11.3.0, 11.4.0
CUDA version numbers supported by Ubuntu20.04: 11.0, 11.1, 11.2.0, 11.3.0, 11.4.0
2. Basic use
2.1 Preparations
install nvidia driver
Install docker and nvidia-container-runtime.
Note that the nvidia version driver, the old version driver does not support the new version of the cuda container.

2.2 Quick use
docker pull: pull the image

docker pull gezp/ubuntu-desktop:20.04-cu11.0
# Domestic users can use Alibaba Cloud Warehouse
# docker pull registry.cn-hongkong.aliyuncs.com/gezp/ubuntu-desktop:20.04-cu11.0
docker run: create and run a container

# The host needs to run xhost to allow all users to access X11 services (run once), the host environment variable $DISPLAY must be 0
xhost +
# Support ssh and 3D GUI
docker run -d --restart=on-failure \
    --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all \
    --shm-size=1024m \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -p 10022:22 \
    -p 14000:4000 \
    gezp/ubuntu-desktop:20.04-cu11.0
The default username and password are both ubuntu
ssh connection container

#ssh access container
ssh ubuntu@host-ip -p 10022
Accessible with vscode + remote ssh plugin
Remote Desktop Connection Container

Download the nomachine software, the ip is the host ip, the port is 14000, and you can connect
3. Extended use
3.1 Customize User Parameters
When creating a container, you can use environment variables to customize the USER, PASSWORD, GID, UID configuration, for example:

docker run -d --restart=on-failure \
    --name my_workspace \
    --cap-add=SYS_PTRACE \
    --gpus all \
    -e USER=cat \
    -e PASSWORD=cat123 \
    -e GID=1001 \
    -e UID=1001 \
    --shm-size=1024m \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -p 10022:22 \
    -p 14000:4000 \
    gezp/ubuntu-desktop:20.04-cu11.0
3.2 3D hardware rendering acceleration
Test VirtualGL

vglrun glxinfo | grep -i "opengl"
If the display contains the NVIDIA GPU model, it is correct
DISPLAY on host must be: 0 .

When running 3D software, you need to add the vglrun command prefix, such as vglrun gazebo.

3.3 Instructions for using CUDA
You need to add the following statement to the .bashrc file to update the environment variables

export CUDA_HOME=/usr/local/cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
For more instructions on using the nvidia/cuda Docker image.
4. Local image build
E.g

git clone https://github.com/gezp/docker-ubuntu-desktop.git
cd docker-ubuntu-desktop
# for 20.04 (based on nvidia/opengl base image)
./docker_build.sh 20.04
# for 20.04-cu11.0 (based on nvidia/cudagl base image)
./docker_build.sh 20.04-cu11.0
