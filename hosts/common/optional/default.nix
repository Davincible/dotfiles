{ config, ... }: {
  imports = [
    ./x11.nix
    ./desktop.nix
    ./nvidia.nix
  ];
}
