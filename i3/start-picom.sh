#!/bin/bash
killall -q picom
sleep .05
picom --xrender-sync-fence --blur-strength 8 --blur-method dual_kawase &>/dev/null &
