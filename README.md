Just some notes for myself:
* https://gitlab.com/Zaney/zaneyos
* https://github.com/juminai/dotfiles
* https://github.com/Aylur/dotfiles << amazing dots

https://github.com/diamondburned/dissent

Looks interesting:
 * https://github.com/wez/wezterm


Things to bar:
* nightlight
* performance
* black / white
* keyboardlighting

TODO: 
 *https://github.com/jirutka/swaylock-effects
 * swww daemon
 * Sway Idle
 ```
swayidle -w \
timeout 120 ' swaylock ' \
timeout 400 ' hyprctl dispatch dpms off' \
timeout 12000 'systemctl suspend' \
resume ' hyprctl dispatch dpms on' \
before-sleep 'swaylock'
 ```
