{ pkgs, inputs, config, lib, configLib, ... }:
let
  username = "tyler";
  passwordSecret = "passwords/${username}";
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  sopsHashedPasswordFile = lib.optionalString (lib.hasAttr "sops" inputs) config.sops.secrets."${passwordSecret}".path;
  pubKeys = lib.filesystem.listFilesRecursive (configLib.relativeToRoot "keys/");
in
{
  # Decrypt ta-password to /run/secrets-for-users/ so it can be used to create the user
  sops.secrets."${passwordSecret}".neededForUsers = true;
  users.mutableUsers = false; # Required for password to be set via sops during system activation!

  users.users.${username} = {
    name = username;
    isNormalUser = true;
    hashedPasswordFile = sopsHashedPasswordFile;
    extraGroups = [
      "wheel"
    ] ++ ifTheyExist [
      "audio"
      "video"
      "docker"
      "git"
      "networkmanager"
    ];
    # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
    # TODO: move to server
    # openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

    shell = pkgs.zsh; # default shell

    packages = [ pkgs.home-manager ];
  };

  # Import this user's host specific personal/home configurations
  # TODO: setup home-manager config
  home-manager.users.${username} = import (configLib.relativeToRoot "home/${username}/${config.networking.hostName}.nix");
}
