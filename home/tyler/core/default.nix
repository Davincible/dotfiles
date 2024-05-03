{ config, lib, pkgs, outputs, ... }:
{
  imports = [

    # Packages with custom configs go here

    # ./bash.nix # backup shell
    # ./bat.nix # cat with better syntax highlighting and extras like batgrep.
    # ./direnv.nix # shell environment manager. Hooks inot shell direnv to look for .envrc before prompts
    # ./fonts.nix # core fonts
    # ./git.nix # personal git config
    # ./kitty.nix # terminal
    # ./nixvim # vim goodness
    # ./screen.nix # hopefully rarely needed but good to have if so
    # ./ssh.nix # personal ssh configs
    # ./zoxide.nix # cd replacement
    # ./zsh # primary shell: includes zsh, oh-my-zsh, and p10k theme

    # TODO: Not set, need to investigate but will need custom config if used:
    # ./shellcolor.nix
  ];

  home = {
    language.base = "en_US.UTF-8";

    username = lib.mkDefault "tyler";

    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    stateVersion = lib.mkDefault "23.11";

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts"
    ];

    sessionVariables = {
      FLAKE = "/home/tyler/dotfiles";
      SHELL = "zsh";
      TERM = "kitty";
      TERMINAL = "kitty";
      EDITOR = "nvim";
      MANPAGER = "batman"; # see ./cli/bat.nix
    };

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    packages = builtins.attrValues {
      inherit (pkgs)

        # Packages that don't have custom configs go here

        # TODO: spaces before comment are removed by nixpkgs-fmt
        # See: https://github.com/nix-community/nixpkgs-fmt/issues/305
        borgbackup  # backups
        btop  # resource monitor
        coreutils  # basic gnu utils
        curl
        eza  # ls replacement
        fd  # tree style ls
        findutils  # find
        fzf  # fuzzy search
        jq  # JSON pretty printer and manipulator
        nix-tree  # nix package tree viewer
        ncdu  # TUI disk usage
        pciutils
        pfetch  # system info
        pre-commit  # git hooks
        p7zip  # compression & encryption
        ripgrep 
        usbutils
        tree 
        unzip
        unrar 
        wget
        zip  # zip compression
        lsd  # Better ls
        bat  # Better man

        # Browsers
        chromium
        opera;
    };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
