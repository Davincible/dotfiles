{ inputs, outputs, config, lib, specialArgs, home-manager, ... }:

let homeManagerSessionVars = "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
  in {
  imports = [
    ./options.nix
    ./locale.nix # localization settings
    ./nix.nix # nix settings and garbage collection
    ./zsh.nix
    ./nvim.nix  # Bare bones nvim
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

  # I saw this somewhere but can't find it?
  # programs.home-manager.enable = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs specialArgs; };

  environment.shellInit = ''
    echo "Hello from shellInit 1 ${homeManagerSessionVars}"
    [[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}
    [[ -f ${homeManagerSessionVars} ]] && echo "file exists" || echo "file doesn't exist"
  '';

  environment.loginShellInit = ''
    if [ -e $HOME/.profile ]
    then
    	. $HOME/.profile
    fi
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
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
