#!/bin/bash
killall -q picom
sleep .05
picom --xrender-sync-fence --blur-strength 5 --blur-method dual_kawase &>/dev/null &
