
ctrlz() {
  if [[ $#BUFFER == 0 ]]; then
    fg >/dev/null 2>&1 && zle redisplay
  else
    zle push-input
  fi
}


function zvm_after_init() # wrap in vi mode plugin function
{
    # Use fd (https://github.com/sharkdp/fd) instead of the default find
    # command for listing path candidates.
    # - The first argument to the function ($1) is the base path to start traversal
    # - See the source code (completion.{bash,zsh}) for the details.
    _fzf_compgen_path() {
      fd --max-depth 2 --hidden --follow --exclude ".git" --exclude ".snapshots" . "$1"
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
      fd --max-depth 2 --type d --hidden --follow --exclude ".git" --exclude ".snapshots" . "$1"
    }

    # Fzf fuzzy finder
    if [[ -e /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
        source /usr/share/fzf/completion.zsh
    fi

    export FZF_DEFAULT_COMMAND='fd --follow --exclude .git --exclude .snapshots --hidden --strip-cwd-prefix'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --max-depth 8"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d --max-depth 8"

}

function zvm_after_lazy_keybindings() {
    # zle -N ctrlz
    # zvm_bindkey vicmd '^Z' ctrlz
}

bindkey -M viins  "^[[1~" beginning-of-line
bindkey -M viins  "^[[4~" end-of-line
bindkey -M viins  "^[[3~" delete-char
bindkey -M vicmd  "^[[1~" beginning-of-line
bindkey -M vicmd  "^[[4~" end-of-line
bindkey -M vicmd  "^[[3~" delete-char
bindkey -M visual "^[[1~" beginning-of-line
bindkey -M visual "^[[4~" end-of-line
bindkey -M visual "^[[3~" delete-char

# bindkey -M viins   "^Z" ctrlz
# bindkey -M vicmd   "^Z" ctrlz
# bindkey -M visual  "^Z" ctrlz

