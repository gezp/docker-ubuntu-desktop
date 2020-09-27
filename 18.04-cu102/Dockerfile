From  vistart/cuda:10.2-devel-ubuntu18.04

LABEL maintainer "zhengpeng ge"
MAINTAINER zhengpeng ge "https://github.com/gezp"
ENV REFRESHED_AT 2020-9-27

# Configure user
ARG user=ubuntu
ARG passwd=ubuntu
ARG uid=1000
ARG gid=1000
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=$user \
    PASSWD=$passwd \
    UID=$uid \
    GID=$gid \
    TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 \
    LC_ALL=${LANG} \
    LANGUAGE=${LANG}
ENV NOMACHINE_PACKAGE_NAME=nomachine_6.11.2_1_amd64.deb \
    NOMACHINE_BUILD=6.11 \
    NOMACHINE_MD5=d268d38823489c9b3cffd5d618c05b22
#add user
RUN groupadd $USER && \
    useradd --create-home --no-log-init -g $USER $USER && \
    usermod -aG sudo $USER && \
    echo "$PASSWD:$PASSWD" | chpasswd && \
    chsh -s /bin/bash $USER && \
    # Replace 1000 with your user/group id
    usermod  --uid $UID $USER && \
    groupmod --gid $GID $USER

#remove /etc/apt/sources.list.d/* (cuda and nvidia-ml repo in vistart/cuda)
RUN rm -rf /etc/apt/sources.list.d/*

## Install some common tools and xfce4 desktop
RUN apt-get update  && \
    apt-get install -y sudo vim wget curl net-tools mesa-utils locales bzip2 git python3-pip \
    python-numpy openssh-server software-properties-common fonts-wqy-zenhei xfce4 xfce4-terminal && \
    rm -rf /var/lib/apt/lists/* 

RUN locale-gen zh_CN.UTF-8

#upgrade pip
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U && \
    rm -rf ~/.cache/pip
  
### Switch to user to install additional software
USER $USER
#set python package tsinghua source
RUN  pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
### Switch to root 
USER 0

# install nomachine remote desktop
RUN curl -fSL "http://download.nomachine.com/download/${NOMACHINE_BUILD}/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb && \
    echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - && dpkg -i nomachine.deb && sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg &&\
    sed -i '/DefaultDesktopCommand/c\DefaultDesktopCommand "/usr/bin/startxfce4"' /usr/NX/etc/node.cfg
#keep English for user(ubuntu) home directory 
RUN LANG=C xdg-user-dirs-update --force

# Run it
EXPOSE 22 4000
ADD nxserver.sh /
RUN chmod +x /nxserver.sh
ENTRYPOINT ["/nxserver.sh"]