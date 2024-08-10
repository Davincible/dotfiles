{ config, lib, pkgs, ... }: {
  imports = [
    ./pipewire.nix
    ./greetd.nix
  ];

  security.pam.services.login.fprintAuth = false;
  # similarly to how other distributions handle the fingerprinting login
  # TODO: kde keyring
  security.pam.services.gdm-fingerprint = lib.mkIf (config.services.fprintd.enable) {
    text = ''
      auth       required                    pam_shells.so
      auth       requisite                   pam_nologin.so
      auth       requisite                   pam_faillock.so      preauth
      auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
      auth       optional                    pam_permit.so
      auth       required                    pam_env.so
      auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
      auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
    
      account    include                     login
    
      password   required                    pam_deny.so
    
      session    include                     login
      session    optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
    '';
  };

  users.groups.scanner = {};
  users.groups.plugdev = {};

  # NOTE: added temp for now so xwayland works
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  users.users.greeter = {
    isSystemUser = true;
    extraGroups = [
      "scanner"
      "plugdev"
      "input"
      "wheel"
    ];
  };

  programs.ssh.startAgent = true;

  hardware.bluetooth = {
    enable = true;
  };

  services = {
    # Enable CUPS to print documents.
    printing.enable = lib.mkDefault true;

    geoclue2.enable = true;

    # Enable touchpad support (enabled by default in most desktopManager).
    libinput.enable = lib.mkDefault true;

    # Fingerprint Sensor
    # fprintd.enable = lib.mkDefault false;
    fprintd.enable = lib.mkForce false;

    upower = {
      enable = true;
      percentageAction = 5;
      percentageCritical = 10;
      percentageLow = 15;
    };
  };

  nixpkgs.config.packageOverrides =
    pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {
        enableHybridCodec = true;
      };
    };


  # Emulate mouse wheel on trackpoint
  # hardware.trackpoint.emulateWheel = true;

  hardware = {
    graphics = {
      enable = true;
      # Deprecated
      # driSupport = true;
      # setLdLibraryPath = true;
      # driSupport32Bit = true;
      extraPackages = with pkgs; [
        # libGL
        # libGL.dev
        # libglvnd
        # libglvnd.dev

        intel-media-driver
        # vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    logitech = {
      wireless = {
        enable = lib.mkDefault true;
        enableGraphical = lib.mkDefault true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # Terminals
    kitty
    upower

    # Browsers
    firefox

    # Desktop apps
    wdisplays # arandr for Wayland
    kanshi # autorandr for Wayland
  ];
}
