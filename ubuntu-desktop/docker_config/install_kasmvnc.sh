#!/bin/sh
version=1.3.2
if [[ $codename == 'bionic' ]]; then
    version=1.3.1
fi
arch=$(dpkg --print-architecture)
codename=$(lsb_release --short --codename)
curl -fSL "https://github.com/kasmtech/KasmVNC/releases/download/v${version}/kasmvncserver_${codename}_${version}_$arch.deb" -o kasmvncserver.deb
apt-get install -y kasmvncserver.deb
rm kasmvncserver.deb
# config kasmvnc
sed -i 's/exec xfce4-session/xset s off;&/' /usr/lib/kasmvncserver/select-de.sh
