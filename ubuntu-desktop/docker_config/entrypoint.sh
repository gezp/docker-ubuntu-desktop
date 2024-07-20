#!/bin/sh
## initialize environment
if [ ! -f "/docker_config/init_flag" ]; then
    # create user
    groupadd -g $GID $USER
    useradd --create-home --no-log-init -u $UID -g $GID $USER
    usermod -aG sudo $USER
    echo "$USER:$PASSWORD" | chpasswd
    chsh -s /bin/bash $USER
    # config nomachine
    sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg
    sed -i '/DefaultDesktopCommand/c\DefaultDesktopCommand "xset s off && /usr/bin/startxfce4"' /usr/NX/etc/node.cfg
    # config kasmvnc
    addgroup $USER ssl-cert
    su $USER -c "echo -e \"$PASSWORD\n$PASSWORD\n\" | vncpasswd -u $USER -o -w -r"
    # vgl for user
    echo "export PATH=/usr/NX/scripts/vgl:\$PATH" >> /home/$USER/.bashrc
    echo "export VGL_DISPLAY=$VGL_DISPLAY" >> /home/$USER/.bashrc
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
# start sshd & remote desktop
/usr/sbin/sshd
/etc/init.d/dbus start
if [ "${REMOTE_DESKTOP}" = "nomachine" ]; then
    echo "start nomachine"
    /etc/NX/nxserver --startup
    tail -f /usr/NX/var/log/nxserver.log
elif [ "${REMOTE_DESKTOP}" = "kasmvnc" ]; then
    echo "start kasmvnc"
    rm -rf /tmp/.X1000-lock /tmp/.X11-unix/X1000
    su $USER -c "vncserver :1000 -select-de xfce \
             -interface 0.0.0.0 -websocketPort 4000 -RectThreads $VNC_THREADS"
    su $USER -c "pulseaudio --start"
    tail -f /home/$USER/.vnc/*.log
else
    echo  "unspported remote desktop: $REMOTE_DESKTOP"
fi
