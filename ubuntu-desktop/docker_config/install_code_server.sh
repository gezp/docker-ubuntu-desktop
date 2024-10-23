#!/bin/bash
version=4.93.1
arch=$(dpkg --print-architecture)
curl -fSL "https://github.com/coder/code-server/releases/download/v${version}/code-server_${version}_${arch}.deb" -o code-server.deb
dpkg -i ./code-server.deb
rm code-server.deb
