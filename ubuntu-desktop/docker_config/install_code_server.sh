#!/bin/bash
CODE_SERVER_VERSION=4.93.1
ARCH=$(dpkg --print-architecture)
curl -fSL "https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_${ARCH}.deb" -o code-server.deb
dpkg -i ./code-server.deb
rm code-server.deb
