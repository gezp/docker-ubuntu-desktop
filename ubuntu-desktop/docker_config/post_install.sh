#!/bin/sh
apt-get update
# Install remote desktop (nomachine,kasmvnc,novnc)
bash /docker_config/install_nomachine.sh
bash /docker_config/install_kasmvnc.sh
bash /docker_config/install_novnc.sh
# Install code server
bash /docker_config/install_code_server.sh
