{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # dev
    podman
    podman-tui
    podman-compose
    go

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
    gnupg  # GPG signing for git commits

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

    # TODO: remove later
    docker
    nodejs_20
    prettierd

    # TODO: move
    telegram-desktop
    signal-desktop
    (opera.override { proprietaryCodecs = true; })
  ];
}
