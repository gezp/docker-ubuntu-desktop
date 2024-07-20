#!/bin/sh
arch=$(dpkg --print-architecture)
codename=$(lsb_release --short --codename)
releases_version=1.3.1
wget -nv https://github.com/kasmtech/KasmVNC/releases/download/v${releases_version}/kasmvncserver_${codename}_${releases_version}_$arch.deb -P /tmp
apt-get update
apt-get install -y /tmp/kasmvncserver*.deb
rm  /tmp/kasmvncserver*.deb
