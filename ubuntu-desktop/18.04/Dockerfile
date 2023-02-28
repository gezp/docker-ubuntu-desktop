ARG BASE_IMAGE=nvidia/opengl:1.2-glvnd-devel-ubuntu18.04
From $BASE_IMAGE

LABEL maintainer "zhengpeng ge"
MAINTAINER zhenpeng ge "https://github.com/gezp"

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu \
    PASSWORD=ubuntu \
    UID=1000 \
    GID=1000 \
    TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8

## Remove /etc/apt/sources.list.d/* 
RUN rm -rf /etc/apt/sources.list.d/*

## Install some common tools 
RUN apt-get update  && \
    apt-get install -y sudo vim gedit locales wget curl git gnupg2 lsb-release net-tools iputils-ping mesa-utils \
                    openssh-server bash-completion software-properties-common python3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2 && \
    pip3 install --upgrade pip &&\
    locale-gen zh_CN.UTF-8 &&\
    rm -rf /var/lib/apt/lists/* 

## Install desktop and chrome
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-power-manager terminator fonts-wqy-zenhei &&\
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&\
    apt-get install -yf ./google-chrome-stable_current_amd64.deb &&\
    rm google-chrome-stable_current_amd64.deb &&\
    rm -rf /var/lib/apt/lists/*

ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
RUN apt-get update && apt-get install -y pulseaudio && mkdir -p /var/run/dbus &&\
    rm -rf /var/lib/apt/lists/*

## Install nomachine
RUN curl -fSL "https://www.nomachine.com/free/linux/64/deb" -o nomachine.deb &&\
    dpkg -i nomachine.deb &&\
    groupmod -g 2000 nx &&\
    rm nomachine.deb &&\
    sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg &&\
    sed -i '/DefaultDesktopCommand/c\DefaultDesktopCommand "/usr/bin/startxfce4"' /usr/NX/etc/node.cfg

## Configure ssh 
RUN mkdir /var/run/sshd &&  \
    echo 'root:THEPASSWORDYOUCREATED' | chpasswd && \
    sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

## Copy config
COPY docker_config /docker_config

EXPOSE 22 4000

ENTRYPOINT ["/docker_config/startup.sh"]
