{ inputs, outputs, config, lib, specialArgs, home-manager, ... }:

{
  imports = [
    ./options.nix
    ./locale.nix # localization settings
    ./nix.nix # nix settings and garbage collection
    ./zsh.nix
    ./nvim.nix  # Bare bones nvim
    ./packages.nix
    ./networking.nix
    ./sops.nix # secrets management

    inputs.home-manager.nixosModules.default
    inputs.home-manager.nixosModules.home-manager

    # ./services/auto-upgrade.nix # auto-upgrade service
  ];

  security.sudo.extraConfig =
    ''
      Defaults timestamp_timeout=120 # only ask for password every 2h
      # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
      # Defaults env_keep + =SSH_AUTH_SOCK
    '';

  # I saw this somewhere but can't find it?
  # programs.home-manager.enable = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs specialArgs; };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    cpu = {
      intel = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };
}
