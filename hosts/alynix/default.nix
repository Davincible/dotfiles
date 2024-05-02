# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, configLib, ... }:

{
  imports = [
    #################### Hardware Modules ####################
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.lenovo-thinkpad-p1

    #################### Required Configs ####################
    (configLib.relativeToRoot "hosts/common/core")


    #################### Optional Configs ####################
    (configLib.relativeToRoot "hosts/common/optional")

    #################### Users to Create ####################
    (configLib.relativeToRoot "hosts/common/users/tyler")
  ];

  hostConfig = {
    addSshKeys = true;
  };

  networking = {
    hostName = "alynix";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.tyler = {
  #   isNormalUser = true;
  #   description = "David Brouwer";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   shell = pkgs.zsh;
  #   packages = with pkgs; [
  #   #  thunderbird
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # List services that you want to enable:

  # TODO: move server.nix
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";
}
