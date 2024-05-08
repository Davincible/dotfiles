{ pkgs, ... }:
{
  programs.starship = {
    enable = false;
    enableZshIntegration = true;
    enableTransience = true;

    settings = {
      add_newline = true;
    };
  };

  programs.zsh = {
    enable = true;

    # relative to $HOME
    dotDir = ".config/zsh";

    enableCompletion = true;

    syntaxHighlighting.enable = true;

    autocd = true;

    zprof.enable = false;

    # TODO: sync with theme?
    # autosuggestions.highlightStyle = ??;
    autosuggestion = {
      enable = true;
    };

    history = {
      size = 100000;
      share = true;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k;
        file = "p10k.zsh";
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      # Edit config files
      edit_config () {
      	nvim $1 -c ":cd $(dirname $1)"
      }

      # eval "$(starship init zsh)"

      # This command let's me execute arbitrary binaries downloaded through channels such as mason.
      # TODO: refactor lsps https://pastebin.ai/xnzful32hm
      # export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';

    oh-my-zsh = {
      enable = false;

      theme = "random"; # apple is kinda nice

      plugins = [
        "git"
        "sudo" # press Esc twice to get the previous command prefixed with sudo https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
      ];

      extraConfig = ''
        # Display red dots whilst waiting for completion.
        COMPLETION_WAITING_DOTS="true"
      '';
    };

    shellAliases = {
      # Overrides those provided by OMZ libs, plugins, and themes.
      # For a full list of active aliases, run `alias`.

      #------------Navigation------------
      doc = "cd $HOME/Documents";
      scripts = "cd $HOME/Scripts";
      l = "eza -lah";
      la = "eza -lah";
      ll = "eza -lh";
      ls = "eza";
      lsa = "eza -lah";

      #-------------Neovim---------------
      e = "nvim";
      vi = "nvim";
      vim = "nvim";

      #-------------Config---------------
      enix = "edit_config ~/dotfiles";
      envim = "edit_config ~/Launchpad/dotfiles/davincible/nvim";

      #-----------Nix related----------------
      ne = "nix-instantiate --eval";
      # nb = "nix-build";
      ns = "nix-shell";

      #-----------Remotes----------------
      # cakes = "ssh -l freshcakes freshcakes.memeoid.cx";

      #-------------Git Goodness-------------
      # just reference `$ alias` and use the defautls, they're good.

      #-------------Development-------------
      go = "richgo";
    };
  };
}
