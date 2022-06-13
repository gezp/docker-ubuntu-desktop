ARG BASE_IMAGE=nvidia/opengl:1.2-glvnd-devel-ubuntu20.04
From $BASE_IMAGE

LABEL maintainer "zhengpeng ge"
MAINTAINER zhenpeng ge "https://github.com/gezp"

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu \
    PASSWD=ubuntu \
    UID=1000 \
    GID=1000 \
    TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8

## Add default user
RUN groupadd $USER && \
    useradd --create-home --no-log-init -g $USER $USER && \
    usermod -aG sudo $USER && \
    echo "$PASSWD:$PASSWD" | chpasswd && \
    chsh -s /bin/bash $USER && \
    # Replace 1000 with your user/group id
    usermod  --uid $UID $USER && \
    groupmod --gid $GID $USER

## Remove /etc/apt/sources.list.d/* 
RUN rm -rf /etc/apt/sources.list.d/*

## Install some common tools 
RUN apt-get update  && \
    apt-get install -y sudo vim gedit locales wget curl git gnupg2 lsb-release net-tools iputils-ping mesa-utils \
                    openssh-server bash-completion software-properties-common python3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2 && \
    pip3 install --upgrade pip &&\
    rm -rf /var/lib/apt/lists/* 

## Install desktop
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-terminal xfce4-power-manager xfce4-screensaver fonts-wqy-zenhei &&\
    locale-gen zh_CN.UTF-8

## Install Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&\
    apt-get install -yf ./google-chrome-stable_current_amd64.deb &&\
    rm google-chrome-stable_current_amd64.deb

ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
RUN apt-get install -y pulseaudio && mkdir -p /var/run/dbus

## Install nomachine
RUN curl -fSL "https://www.nomachine.com/free/linux/64/deb" -o nomachine.deb &&\
    dpkg -i nomachine.deb &&\
    rm nomachine.deb &&\
    sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg &&\
    sed -i '/DefaultDesktopCommand/c\DefaultDesktopCommand "/usr/bin/startxfce4"' /usr/NX/etc/node.cfg

## Configure ssh 
RUN mkdir /var/run/sshd &&  \
    echo 'root:THEPASSWORDYOUCREATED' | chpasswd && \
    sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

## Set .bashrc
RUN  echo "export PATH=/usr/NX/scripts/vgl:\$PATH" >> /home/$USER/.bashrc

## Copy config
COPY config/xfce4 /home/$USER/.config/xfce4
RUN chown -R $GID:$UID /home/$USER/.config

EXPOSE 22 4000

COPY nxserver.sh /
RUN chmod +x /nxserver.sh
ENTRYPOINT ["/nxserver.sh"]
