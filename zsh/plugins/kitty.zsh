### Set kitty values
if [[ $TERM == "xterm-kitty" ]]; then 
    autoload -Uz compinit
    compinit

    # Completion for kitty
    source <(kitty + complete setup zsh)

    # Set colors
    kitty @ set-colors -a -c $KITTY_CONFIG_PATH/colors-kitty.conf

    # Set opacity
    opacity=$(cat $KITTY_CONFIG_PATH/colors-kitty.conf | grep -m1 background_opacity | awk '{ print $2 }')
    kitty @ set-background-opacity -a $opacity
fi

