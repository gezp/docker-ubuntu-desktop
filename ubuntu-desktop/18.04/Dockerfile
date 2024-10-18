ARG BASE_IMAGE=ubuntu:18.04
From $BASE_IMAGE

LABEL maintainer "zhengpeng ge"
MAINTAINER zhenpeng ge "https://github.com/gezp"

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu \
    PASSWORD=ubuntu \
    UID=1000 \
    GID=1000

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV SERVER_SSL_CERT=/etc/ssl/certs/ssl-cert-snakeoil.pem
ENV SERVER_SSL_KEY=/etc/ssl/private/ssl-cert-snakeoil.key
ENV VGL_DISPLAY=egl
ENV REMOTE_DESKTOP=nomachine
ENV VNC_THREADS=2

## Copy config
COPY docker_config /docker_config

## Install and Configure OpenGL
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libxau6 libxdmcp6 libxcb1 libxext6 libx11-6 \
        libglvnd0 libgl1 libglx0 libegl1 libgles2 \
        libglvnd-dev libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/share/glvnd/egl_vendor.d/ && \
    echo "{\n\
\"file_format_version\" : \"1.0.0\",\n\
\"ICD\": {\n\
    \"library_path\": \"libEGL_nvidia.so.0\"\n\
}\n\
}" > /usr/share/glvnd/egl_vendor.d/10_nvidia.json

## Install and Configure Vulkan
RUN apt-get update && \
    apt-get install -y --no-install-recommends vulkan-utils && \
    rm -rf /var/lib/apt/lists/* && \
    VULKAN_API_VERSION=$(dpkg -s libvulkan1 | grep -oP 'Version: [0-9|\.]+' | grep -oP '[0-9]+(\.[0-9]+)(\.[0-9]+)') && \
    mkdir -p /etc/vulkan/icd.d/ && \
    echo "{\n\
\"file_format_version\" : \"1.0.0\",\n\
\"ICD\": {\n\
    \"library_path\": \"libGLX_nvidia.so.0\",\n\
    \"api_version\" : \"${VULKAN_API_VERSION}\"\n\
}\n\
}" > /etc/vulkan/icd.d/nvidia_icd.json

## Install some common tools 
RUN bash /docker_config/install_common.sh &&\
    rm -rf /var/lib/apt/lists/* 

## Install desktop
RUN apt-get update && \
    # add apt repo for firefox
    add-apt-repository -y ppa:mozillateam/ppa &&\
    mkdir -p /etc/apt/preferences.d &&\
    echo "Package: firefox*\n\
Pin: release o=LP-PPA-mozillateam\n\
Pin-Priority: 1001" > /etc/apt/preferences.d/mozilla-firefox &&\
    # install xfce4 and firefox
    apt-get install -y xfce4 terminator fonts-wqy-zenhei ffmpeg firefox &&\
    # disable terminator dbus
    sed -i "s/python/python2/" /usr/share/terminator/terminator &&\
    sed -i "s/if OPTIONS.nodbus:/if True:/" /usr/share/terminator/terminator &&\
    # set firefox as default web browser
    update-alternatives --set x-www-browser /usr/bin/firefox &&\
    #
    update-locale LC_CTYPE=C.UTF-8 &&\
    rm -rf /var/lib/apt/lists/*

ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
RUN apt-get update && apt-get install -y pulseaudio && mkdir -p /var/run/dbus &&\
    rm -rf /var/lib/apt/lists/*

## Install remote desktop (nomachine,kasmvnc,novnc)
RUN bash /docker_config/install_nomachine.sh &&\
    bash /docker_config/install_kasmvnc.sh &&\
    bash /docker_config/install_novnc.sh &&\
    rm -rf /var/lib/apt/lists/*

## Configure ssh 
RUN mkdir /var/run/sshd &&  \
    echo root:$PASSWORD | chpasswd && \
    sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

EXPOSE 22 4000

ENTRYPOINT ["/docker_config/entrypoint.sh"]
