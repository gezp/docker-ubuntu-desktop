#!/bin/sh
version=1.3.2
arch=$(dpkg --print-architecture)
codename=$(lsb_release --short --codename)
if [[ $codename == 'bionic' ]]; then
    version=1.3.1
fi
curl -fSL "https://github.com/kasmtech/KasmVNC/releases/download/v${version}/kasmvncserver_${codename}_${version}_$arch.deb" -o /tmp/kasmvncserver.deb
apt-get install -y /tmp/kasmvncserver.deb
rm /tmp/kasmvncserver.deb
# config kasmvnc
sed -i 's/exec xfce4-session/xset s off;&/' /usr/lib/kasmvncserver/select-de.sh
