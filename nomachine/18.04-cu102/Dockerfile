From  gezp/ubuntu_base:18.04-cu102

LABEL maintainer "zhengpeng ge"
MAINTAINER zhengpeng ge "https://github.com/gezp"
ENV REFRESHED_AT 2020-9-27

ENV NOMACHINE_PACKAGE_NAME=nomachine_6.11.2_1_amd64.deb \
    NOMACHINE_BUILD=6.11 \
    NOMACHINE_MD5=d268d38823489c9b3cffd5d618c05b22

## Installxfce4 desktop
RUN apt-get update xfce4 xfce4-terminal xfce4-screensaver && \
    rm -rf /var/lib/apt/lists/* 

# install nomachine remote desktop
RUN curl -fSL "http://download.nomachine.com/download/${NOMACHINE_BUILD}/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb && \
    echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - &&\
    dpkg -i nomachine.deb &&\
    sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg &&\
    sed -i '/DefaultDesktopCommand/c\DefaultDesktopCommand "/usr/bin/startxfce4"' /usr/NX/etc/node.cfg
#keep English for user(ubuntu) home directory 
RUN LANG=C xdg-user-dirs-update --force

# Run it
EXPOSE 22 4000
ADD nxserver.sh /
RUN chmod +x /nxserver.sh
ENTRYPOINT ["/nxserver.sh"]