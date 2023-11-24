#!/bin/sh
arch=$(dpkg --print-architecture)
if [[ $arch == 'amd64' ]]; then
    curl -fSL "https://www.nomachine.com/free/linux/64/deb" -o nomachine.deb
elif  [[ $arch == 'arm64' ]]; then
    curl -fSL "https://www.nomachine.com/free/arm/64/deb" -o nomachine.deb
else
    echo "unsupported architecture: $arch"
    exit -1
fi

dpkg -i nomachine.deb
rm nomachine.deb
