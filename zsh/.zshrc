# Paths
export ZSH_CONFIG_PATH="$HOME/.config/zsh"
export KITTY_CONFIG_PATH="$HOME/.config/kitty"

# Config
export HISTFILE="$HOME/.cache/zsh/history"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

source $ZSH_CONFIG_PATH/functions.zsh

### load zsh defer plugin
load $ZSH_CONFIG_PATH/plugins/zsh-defer/zsh-defer.plugin.zsh

### source other config scripts
load $ZSH_CONFIG_PATH/ohmy.zsh
load $ZSH_CONFIG_PATH/themes/robbyrussel.zsh
defer_load $ZSH_CONFIG_PATH/plugins/init.zsh
defer_load $ZSH_CONFIG_PATH/aliases.zsh
defer_load $ZSH_CONFIG_PATH/keybindings.zsh

# If Using tmux
# [ -z "$TMUX"  ] && { tmux new -s local || exec tmux new -t local } #  && exit }

# Fix Screen Tearing
# Put this in .xinitrc
# nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
