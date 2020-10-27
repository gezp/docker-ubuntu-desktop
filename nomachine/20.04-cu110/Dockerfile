From gezp/ubuntu_base:20.04-cu110

LABEL maintainer "zhengpeng ge"
MAINTAINER zhengpeng ge "https://github.com/gezp"
ENV REFRESHED_AT 2020-10-27
    
## Install desktop
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-terminal xfce4-power-manager xfce4-screensaver fonts-wqy-zenhei


#Install Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&\
    apt-get install -yf ./google-chrome-stable_current_amd64.deb


ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
RUN apt-get install -y pulseaudio x11-utils && mkdir -p /var/run/dbus


## Install nomachine
RUN curl -fSL "https://www.nomachine.com/free/linux/64/deb" -o nomachine.deb &&\
    dpkg -i nomachine.deb &&\
    sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg &&\
    sed -i '/DefaultDesktopCommand/c\DefaultDesktopCommand "/usr/bin/startxfce4"' /usr/NX/etc/node.cfg

# Run it
EXPOSE 22 4000
ADD nxserver.sh /
RUN chmod +x /nxserver.sh
ENTRYPOINT ["/nxserver.sh"]
