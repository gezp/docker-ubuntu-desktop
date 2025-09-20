#!/bin/sh
arch=$(dpkg --print-architecture)
codename=$(lsb_release --short --codename)
# update
apt-get update
# Install remote desktop (nomachine,kasmvnc,novnc)
bash /docker_config/install_nomachine.sh
bash /docker_config/install_kasmvnc.sh
bash /docker_config/install_novnc.sh
# Install code server
CODE_VERSION=4.103.2
if [[ $codename == 'bionic' ]]; then
    CODE_VERSION=4.16.1
fi
curl -fSL "https://github.com/coder/code-server/releases/download/v${CODE_VERSION}/code-server_${CODE_VERSION}_${arch}.deb" -o code-server.deb
dpkg -i ./code-server.deb
rm code-server.deb
