
### source other config scripts
[ -f "$HOME/.config/zsh/plugins.zsh" ] && source ~/.config/zsh/plugins.zsh
[ -f "$HOME/.config/zsh/prompt.zsh" ] && source ~/.config/zsh/prompt.zsh
[ -f "$HOME/.config/zsh/prompt_colors.zsh" ] && source ~/.config/zsh/prompt_colors.zsh
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source ~/.config/zsh/aliases.zsh
[ -f "$HOME/.config/zsh/keybindings.zsh" ] && source ~/.config/zsh/keybindings.zsh

HISTFILE=~/.cache/zsh/history
# [ -z "$TMUX"  ] && { tmux new -s local || exec tmux new -t local } #  && exit }
