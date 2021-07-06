#!/bin/bash
killall -q picom
picom --xrender-sync-fence &>/dev/null
