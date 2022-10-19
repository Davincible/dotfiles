#!/bin/bash

export XSECURELOCK_COMPOSITE_OBSCURER=0
export XSECURELOCK_BACKGROUND_COLOR="#101010"
export XSECURELOCK_AUTH_BACKGROUND_COLOR="#101010"

# Run screen locker
# Dim after 5min, lock 8s after dimmed
xset s 300 8
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock
