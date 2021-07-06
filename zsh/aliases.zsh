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
alias man='vman'
alias pacman='sudo pacman'
alias wifi-connect='nmcli d connect wlp82s0 --ask'
alias nmgui="nm-connection-editor"
alias e3="tmp=`pwd` && cd ~/.config/wpg/templates && nvim i3.base && echo changing back to $tmp && cd $tmp"
alias x="exit"
alias snvim="sudo -E nvim"
alias svim="sudo -E vim"

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

