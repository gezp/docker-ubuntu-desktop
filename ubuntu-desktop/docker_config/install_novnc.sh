#!/bin/sh
NOVNC_VERSION=1.4.0
# install turbovnc
wget -q -O- https://packagecloud.io/dcommander/turbovnc/gpgkey | gpg --dearmor >/etc/apt/trusted.gpg.d/TurboVNC.gpg
wget -O /etc/apt/sources.list.d/TurboVNC.list https://raw.githubusercontent.com/TurboVNC/repo/main/TurboVNC.list
apt-get update
apt-get install -y turbovnc
rm /etc/apt/sources.list.d/TurboVNC.list
# install novnc
curl -fsSL "https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz" | tar -xzf - -C /opt
mv -f "/opt/noVNC-${NOVNC_VERSION}" /opt/noVNC
ln -snf /opt/noVNC/vnc.html /opt/noVNC/index.html
git clone "https://github.com/novnc/websockify.git" /opt/noVNC/utils/websockify
# config turbovnc
echo "xset s off && /usr/bin/startxfce4" > /opt/TurboVNC/bin/xstartup.turbovnc
