# Load wpgtk color scheme
(cat ~/.config/wpg/sequences &)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#### Powerlevel10k & zsh shel config
USE_POWERLINE="true"
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi

# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi


# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh.colormod.zsh ]] || source ~/.p10k.zsh.colormod.zsh
[[ ! -f ~/.config/zsh/colors_prompt.zsh ]] || source ~/.config/zsh/colors_prompt.zsh

if [[ $TERM == "xterm-kitty" ]]; then 
    autoload -Uz compinit
    compinit
    # Completion for kitty
    kitty + complete setup zsh | source /dev/stdin
    kitty @ set-colors -a -c /home/tyler/.config/kitty/colors-kitty.conf
    kitty @ set-background-opacity -a $(cat ~/.config/kitty/colors-kitty.conf | grep -m1 background_opacity | awk '{ print $2 }')
fi

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

