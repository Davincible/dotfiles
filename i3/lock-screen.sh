#!/bin/bash

# Run screen locker
# Dim after 5min, lock 8s after dimmed
xset s 300 8
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- ~/.config/i3/lock.sh
