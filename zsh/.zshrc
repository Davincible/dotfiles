# Paths
export ZSH_CONFIG_PATH="$HOME/.config/zsh"
export KITTY_CONFIG_PATH="$HOME/.config/kitty"
export POWERLEVEL9K_INSTALLATION_DIR="$HOME/powerlevel10k"

# Config
export HISTFILE="$HOME/.cache/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY
export MANPAGER='nvim +Man!'
export MANWIDTH=999

source $ZSH_CONFIG_PATH/functions.zsh

### load zsh defer plugin
load $ZSH_CONFIG_PATH/plugins/zsh-defer/zsh-defer.plugin.zsh

### source other config scripts
# load $ZSH_CONFIG_PATH/ohmy.zsh
defer_load $ZSH_CONFIG_PATH/.zshenv
defer_load $ZSH_CONFIG_PATH/plugins/init.zsh
defer_load $ZSH_CONFIG_PATH/aliases.zsh
defer_load $ZSH_CONFIG_PATH/keybindings.zsh

### Load Theme
# load $ZSH_CONFIG_PATH/themes/robbyrussel.zsh
# load $ZSH_CONFIG_PATH/themes/prompt_colors.zsh
load $ZSH_CONFIG_PATH/themes/powerlevel10k.zsh-theme
load $ZSH_CONFIG_PATH/themes/p10k.zsh

# If Using tmux
# [ -z "$TMUX"  ] && { tmux new -s local || exec tmux new -t local } #  && exit }

# Fix Screen Tearing
# Put this in .xinitrc
# nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
