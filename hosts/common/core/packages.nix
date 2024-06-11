{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs;
    [
      # dev
      podman
      podman-tui
      podman-compose
      go
      anchor
      solana-cli
      blender

      # Tools
      fzf
      ripgrep
      ripgrep-all # ripgrep in pdfs etc
      fd
      gdu
      tealdeer # tldr, but in rust
      nh # Better nix experience
      lsd
      lazygit
      git
      gnupg # GPG signing for git commits
      findutils
      mlocate
      udev
      sd
      tokei
      awscli2
      dig
      obs-studio
      mpv


      # System Deps
      wget
      gparted
      ntfs3g
      smartmontools
      sops # Secret management tool
      age # Age keygen encryption util, used for Sops
      xclip # clipboard for X11
      wl-clipboard # clipboard for Wayland
      git
      htop
      cargo
      gnumake
      openssh
      gcc
      nix-ld-rs # Run aribrary binaries on Nix
      killall

      # TODO: remove later / dev env
      docker
      nodejs_20
      prettierd
      yarn
      stylua
      richgo
      python3
      tree-sitter
      findutils
      glow # markdown preview for telescope

      # TODO: move
      gh
      sqlc
      dbeaver-bin
      telegram-desktop
      signal-desktop
    ];
}
