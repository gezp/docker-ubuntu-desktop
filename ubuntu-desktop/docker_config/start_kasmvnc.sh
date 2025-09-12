#!/bin/sh
# set password for kasmvnc
if [ ! -f "/home/$USER/.vnc/passwd" ]; then
    su $USER -c "echo -e \"$PASSWORD\n$PASSWORD\n\" | kasmvncpasswd -u $USER -o -w -r"
fi
rm -rf /tmp/.X1000-lock /tmp/.X11-unix/X1000
# start kasmvnc
if [ ! -z ${DISABLE_HTTPS+x} ]; then
  su $USER -c "kasmvncserver :1000 -select-de xfce -interface 0.0.0.0 -websocketPort 4000 -sslOnly 0 -RectThreads $VNC_THREADS"
else
  su $USER -c "kasmvncserver :1000 -select-de xfce -interface 0.0.0.0 -websocketPort 4000 -cert $HTTPS_CERT -key $HTTPS_CERT_KEY -RectThreads $VNC_THREADS"
fi
su $USER -c "pulseaudio --start"
tail -f /home/$USER/.vnc/*.log
