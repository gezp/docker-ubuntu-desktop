From  vistart/cuda:10.2-devel-ubuntu20.04

LABEL maintainer "zhengpeng ge"
MAINTAINER zhengpeng ge "https://github.com/gezp"
ENV REFRESHED_AT 2020-9-14

# Configure user
ARG user=ubuntu
ARG passwd=ubuntu
ARG uid=1000
ARG gid=1000
ENV USER=$user
ENV PASSWD=$passwd
ENV UID=$uid
ENV GID=$gid
ENV DEBIAN_FRONTEND=noninteractive
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
    apt-get install -y sudo vim wget curl net-tools mesa-utils locales bzip2 git tmux xterm python3-pip \
    python-numpy openssh-server software-properties-common fonts-wqy-zenhei xfce4 xfce4-terminal && \
    rm -rf /var/lib/apt/lists/* 

#upgrade pip
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U && \
    rm -rf ~/.cache/pip
  
#set language encode and setup environment
RUN locale-gen zh_CN.UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

### Switch to user to install additional software
USER $USER
#set python package tsinghua source
RUN  pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
### Switch to root 
USER 0

# add x2go repository and install x2go
RUN add-apt-repository ppa:x2go/stable && \
    apt-get update && \
    apt-get install -y x2goserver x2goserver-xsession && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* 
# SSH runtime
RUN mkdir /var/run/sshd


# Run it
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
