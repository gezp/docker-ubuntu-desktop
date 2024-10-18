#!/bin/sh
# set password for TurboVNC
if [ ! -f "/home/$USER/.vnc/passwd" ]; then
    su $USER -c "echo -e \"$PASSWORD\n$PASSWORD\ny\n\" | /opt/TurboVNC/bin/vncpasswd"
fi
rm -rf /tmp/.X1000-lock /tmp/.X11-unix/X1000
# start TurboVNC
su $USER -c "/opt/TurboVNC/bin/vncserver :1000 -rfbport 5900"
# start NoVNC
su $USER -c "/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --ssl-only --cert $HTTPS_CERT --key $HTTPS_CERT_KEY --listen 4000 --heartbeat 10 &"
tail -f /home/$USER/.vnc/*.log
