From gezp/ubuntu-nomachine:20.04-cu110

LABEL maintainer "zhengpeng ge"
MAINTAINER zhengpeng ge "https://github.com/gezp"
ENV REFRESHED_AT 2020-10-27
    
#Install ROS2
RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list' &&\
    curl -Ls https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add - &&\
    apt-get update &&\
    apt-get install -y gnupg2 lsb-release ros-foxy-desktop  &&\
    apt-get install -y python3-argcomplete python3-colcon-common-extensions python3-rosdep python3-vcstool 
    
#Install Pytorch
RUN pip3 install torch torchvision

