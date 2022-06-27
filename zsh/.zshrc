
### source other config scripts
[ -f "$HOME/.config/zsh/plugins.zsh" ] && source ~/.config/zsh/plugins.zsh
[ -f "$HOME/.config/zsh/prompt.zsh" ] && source ~/.config/zsh/prompt.zsh
[ -f "$HOME/.config/zsh/prompt_colors.zsh" ] && source ~/.config/zsh/prompt_colors.zsh
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source ~/.config/zsh/aliases.zsh
[ -f "$HOME/.config/zsh/keybindings.zsh" ] && source ~/.config/zsh/keybindings.zsh

HISTFILE=~/.cache/zsh/history
# [ -z "$TMUX"  ] && { tmux new -s local || exec tmux new -t local } #  && exit }

# Command completions
[[ /sbin/kubectl ]] && source <(kubectl completion zsh)
[[ /sbin/k3d ]] && source <(k3d completion zsh)
[[ /sbin/datree ]] && source <(datree completion zsh)
[[ /sbin/helm ]] && source <(helm completion zsh)
[[ /sbin/tobs ]] && source <(tobs completion zsh)
[[ /sbin/go-micro ]] && source <(go-micro completion zsh)
[[ /sbin/cilium ]] && source <(cilium completion zsh)

# Fix Screen Tearing
# Put this in .xinitrc
# nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
