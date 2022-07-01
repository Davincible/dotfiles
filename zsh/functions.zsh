function defer_load () {
    [ -f $1 ] && zsh-defer source $1
}

function load () {
    [ -f $1 ] && source $1
}

