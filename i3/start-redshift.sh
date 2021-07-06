#!/bin/bash
killall -q redshift
# killall -q geoclue
# sleep 0.5
# /usr/lib/geoclue-2.0/demos/agent &>/dev/null
# sleep 1
redshift >/dev/null &

