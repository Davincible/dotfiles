{ config, ... }: {
  imports = [
    ./desktop.nix
    ./x11.nix
    ./nvidia.nix
  ];
}
