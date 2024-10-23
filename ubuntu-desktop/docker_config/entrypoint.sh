#!/bin/sh
## initialize environment
if [ ! -f "/docker_config/init_flag" ]; then
    # set python is python3
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2
    # update /etc/environment
    export PATH=/usr/NX/scripts/vgl:$PATH
    env | grep -Ev "CMD=|PWD=|SHLVL=|_=|DEBIAN_FRONTEND=|USER=|HOME=|UID=|GID=|PASSWORD=" > /etc/environment
    # create user
    groupadd -g $GID $USER
    useradd --create-home --no-log-init -u $UID -g $GID $USER
    usermod -aG sudo $USER
    usermod -aG ssl-cert $USER
    echo "root:$PASSWORD" | chpasswd
    echo "$USER:$PASSWORD" | chpasswd
    chsh -s /bin/bash $USER
    # extra env init for developer
    if [ -f "/docker_config/env_init.sh" ]; then
        bash /docker_config/env_init.sh
    fi
    # custom env init for user
    if [ -f "/docker_config/custom_env_init.sh" ]; then
        bash /docker_config/custom_env_init.sh
    fi
    echo  "ok" > /docker_config/init_flag
fi
## startup
# custom startup for user
if [ -f "/docker_config/custom_startup.sh" ]; then
	bash /docker_config/custom_startup.sh
fi
# start sshd
/usr/sbin/sshd
# start dbus
/etc/init.d/dbus start
# start coder server
su $USER -c "code-server --cert $HTTPS_CERT --cert-key $HTTPS_CERT_KEY --bind-addr=0.0.0.0:5000 &"
# start remote desktop
if [ "${REMOTE_DESKTOP}" = "nomachine" ]; then
    echo "start nomachine"
    bash /docker_config/start_nomachine.sh
elif [ "${REMOTE_DESKTOP}" = "kasmvnc" ]; then
    echo "start kasmvnc"
    bash /docker_config/start_kasmvnc.sh
elif [ "${REMOTE_DESKTOP}" = "novnc" ]; then
    echo "start novnc"
    bash /docker_config/start_novnc.sh
else
    echo  "unspported remote desktop: $REMOTE_DESKTOP"
fi
