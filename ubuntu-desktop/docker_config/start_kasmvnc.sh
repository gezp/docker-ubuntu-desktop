#!/bin/sh
rm -rf /tmp/.X1000-lock /tmp/.X11-unix/X1000
su $USER -c "vncserver :1000 -select-de xfce -interface 0.0.0.0 -websocketPort 4000 -RectThreads $VNC_THREADS"
su $USER -c "pulseaudio --start"
tail -f /home/$USER/.vnc/*.log
