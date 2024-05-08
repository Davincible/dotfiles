{ pkgs, ... }:
{
  programs = {
    hyprland = {
      enable = true;
      # nvidiaPatches = true;  # No longer available?
      # package = config.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland; # default
    };
  };
}
