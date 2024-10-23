#!/bin/bash
version=4.93.1
arch=$(dpkg --print-architecture)
codename=$(lsb_release --short --codename)
if [[ $codename == 'bionic' ]]; then
    version=4.16.1
fi
curl -fSL "https://github.com/coder/code-server/releases/download/v${version}/code-server_${version}_${arch}.deb" -o code-server.deb
dpkg -i ./code-server.deb
rm code-server.deb
