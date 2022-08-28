#!/bin/sh

## initialize environment
if [ ! -f "/docker_config/init" ]; then
    # create user
    groupadd -g $GID $USER
    useradd --create-home --no-log-init -u $UID -g $GID $USER
    usermod -aG sudo $USER
    echo "$USER:$PASSWORD" | chpasswd
    chsh -s /bin/bash $USER
    # copy xfce4 config
    mkdir /home/$USER/.config
    cp -r /docker_config/xfce4 /home/$USER/.config
    chown -R $UID:$GID /home/$USER/.config
    # config user
    su $USER -s /bin/bash /docker_config/config_user.sh
    # update init flag
    echo  "ok" > /docker_config/init
fi

/usr/sbin/sshd
/etc/init.d/dbus start
/etc/NX/nxserver --startup
tail -f /usr/NX/var/log/nxserver.log
