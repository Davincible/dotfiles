{ config, pkgs, ... }:

{
  imports = [
    #################### Required Configs ####################
    ./core #required

    #################### Host-specific Optional Configs ####################
    # ./optional/browsers/chromium.nix
  ];
}
