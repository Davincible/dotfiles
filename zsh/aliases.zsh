# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls aliases
alias ll="ls -al"
alias la="ls -A"
alias l="ls -CF"
alias ls="lsd"

# system program aliases
alias sudo='sudo '
alias python='python3'
alias pypi='pip3 install --user'
# alias man='vman'
alias pacman='sudo pacman'
alias nmgui="nm-connection-editor"

alias x="exit"
alias snvim="sudo -E nvim"
alias svim="sudo -E vim"
alias mkinitcpio="sudo mkinitcpio"
alias b="bluetoothctl"
alias cat="bat"
alias catt="cat"
alias fd="fd -L"
alias sz="source ~/.config/zsh/.zshrc"

# Edit config files
edit_config () {
	nvim $1 -c ":cd $(dirname $1)"
}
CONFIG_DIR="~/.config"

alias e3="edit_config $CONFIG_DIR/wpg/templates/i3.base"
alias envim="edit_config $CONFIG_DIR/nvim/lua/uno/config.lua"
alias ezsh="edit_config $CONFIG_DIR/zsh/.zshrc"
alias ekitty="edit_config $CONFIG_DIR/wpg/templates/config_kitty_colors-kitty.conf.base"

# Open files with default program
function open () {
  xdg-open "$@">/dev/null 2>&1 &
}

# go aliases
alias gb="go build ."
alias gr="go run . || go run main.go"

if [[ $TERM == "xterm-kitty" ]]; then 
    alias icat="kitty +kitten icat"
    alias ssh="kitty +kitten ssh"
fi

# Usage: echo "hi" && alert 'done'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

vman() {
  vim -c "SuperMan $*"
  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
}

# ripgrep-all with fzf support
rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

# User Programs
alias gephi="LIBGL_ALWAYS_SOFTWARE=1 gephi --jdkhome $JAVA8_HOME"

alias tableplus="/usr/bin/env LD_PRELOAD=/opt/tableplus/lib/libldap-2.5.so.0.1.1:/opt/tableplus/lib/liblber-2.5.so.0.1.1:/opt/tableplus/lib/libsasl2.so.2.0.25:/opt/tableplus/lib/libgio-2.0.so.0.6800.4 /usr/local/bin/tableplus"
