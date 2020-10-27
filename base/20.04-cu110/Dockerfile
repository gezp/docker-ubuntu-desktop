From  nvidia/cudagl:11.0-devel-ubuntu20.04

LABEL maintainer "zhengpeng ge"
MAINTAINER zhengpeng ge "https://github.com/gezp"
ENV REFRESHED_AT 2020-10-13

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
    LC_ALL=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8

#add user
RUN groupadd $USER && \
    useradd --create-home --no-log-init -g $USER $USER && \
    usermod -aG sudo $USER && \
    echo "$PASSWD:$PASSWD" | chpasswd && \
    chsh -s /bin/bash $USER && \
    # Replace 1000 with your user/group id
    usermod  --uid $UID $USER && \
    groupmod --gid $GID $USER

#remove /etc/apt/sources.list.d/* 
RUN rm -rf /etc/apt/sources.list.d/*

## Install some common tools 
RUN apt-get update  && \
    apt-get install -y sudo vim wget curl git net-tools mesa-utils gedit openssh-server bash-completion locales \
                    python3-pip python-numpy openssh-server software-properties-common && \
    rm -rf /var/lib/apt/lists/* 

# ssh 
RUN mkdir /var/run/sshd &&  \
    echo 'root:THEPASSWORDYOUCREATED' | chpasswd && \
    sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd



# Run it
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
