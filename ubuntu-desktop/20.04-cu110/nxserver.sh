#!/bin/sh
/etc/NX/nxserver --startup
tail -f /usr/NX/var/log/nxserver.log
