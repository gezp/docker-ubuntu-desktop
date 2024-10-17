#!/bin/sh
apt-get update
apt-get install -y sudo vim locales gnupg2 wget curl lsb-release bash-completion
apt-get install -y net-tools iputils-ping mesa-utils software-properties-common openssh-server
apt-get install -y python3 python3-pip python3-numpy
update-alternatives --install /usr/bin/python python /usr/bin/python3 2
apt-get install -y git git-lfs tmux 
