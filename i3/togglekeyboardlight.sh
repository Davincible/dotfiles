#!/bin/bash

current=$(light -s sysfs/leds/tpacpi::kbd_backlight)
if [ "$current" == "100.00" ]; then
    light -s sysfs/leds/tpacpi::kbd_backlight -U 100
    echo toggle on
else 
    light -s sysfs/leds/tpacpi::kbd_backlight -A 100
    echo toggle off
fi
