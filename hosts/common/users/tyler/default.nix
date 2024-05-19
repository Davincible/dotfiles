{ pkgs, inputs, config, lib, configLib, ... }:
let
  username = "tyler";
  passwordSecret = "passwords/${username}";
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  sopsHashedPasswordFile = lib.optionalString (lib.hasAttr "sops" inputs) config.sops.secrets."${passwordSecret}".path;
in
{
  # Decrypt ta-password to /run/secrets-for-users/ so it can be used to create the user
  # sops.secrets."${passwordSecret}".neededForUsers = true;
  # users.mutableUsers = false; # Required for password to be set via sops during system activation!

  # services.displayManager = {
  # };
    security.polkit.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${lib.getExe config.programs.hyprland.package} --config /path/to/greetd/hyprland.conf";
        user = "greeter";
      };

      default_session = {
        user = "tyler";
        command = "Hyprland";
        #          command = ''${pkgs.greetd.tuigreet}/bin/tuigreet \
        #               -r --asterisks --time \
        # --user-menu-min-uid 1000 \
        # --cmd Hyprland'';
      };
    };
  };

  users.users.${username} = {
    name = username;
    isNormalUser = true;
    # hashedPasswordFile = sopsHashedPasswordFile;
    extraGroups = [
      "wheel"
      "docker"
    ] ++ ifTheyExist [
      "audio"
      "video"
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
