{ inputs, outputs, config, lib, configLib, specialArgs, home-manager, pkgs, ... }:

let homeManagerSessionVars = "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
in {
  imports = [
    ./options.nix
    ./locale.nix # localization settings
    ./nix.nix # nix settings and garbage collection
    ./zsh.nix
    ./nvim.nix # Bare bones nvim
    ./packages.nix
    ./networking.nix
    ./scripts
    # ./sops.nix # secrets management


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

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs configLib specialArgs; };

  environment.shellInit = ''
    # Sourcing Home Manager ENV
    source $(which source-hm)
  '';

  environment.loginShellInit = ''
    [[ -f $HOME/.profile ]] && source $HOME/.profile
  '';

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    cpu = {
      intel = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };

  # Git commit singing with GPG
  # TODO: find a better place to put this
  services.pcscd.enable = true;
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # For signing git requsts with GPG
  programs.gnupg.agent = {
    enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  services.throttled.enable = true;
}
