#!/bin/bash

# Example notifier script -- lowers screen brightness, then waits to be killed
# and restores previous brightness on exit.

## CONFIGURATION ##############################################################

# Brightness will be lowered to this value.
min_brightness=0

fade_time=10

# Default fade sleep, will be calculated
fade_step_time=0.05

###############################################################################

get_fade_sleep_time() {
  set +B
  python -c "
current_brightness = ${1}
target = ${min_brightness}
steps = current_brightness - target
sleep_time = ${fade_time} / steps
print(f\"{sleep_time:.3f}\")"

  set -B
}

get_brightness() {
  # xbacklight -get
  light -s sysfs/backlight/auto -G
}

set_brightness() {
  # xbacklight -steps 1 -set $1
  light -s sysfs/backlight/auto -S "${1}"
}

fade_brightness() {
  current=$(get_brightness)
  fade_step_time=$(get_fade_sleep_time "${current}")

  local level
  for level in $(seq "${current}" -1 "${1}"); do
    set_brightness "${level}"
    sleep "${fade_step_time}"
  done
}

trap 'exit 0' TERM INT
trap "set_brightness $(get_brightness); kill %%" EXIT
fade_brightness $min_brightness
sleep 2147483647 &
wait
