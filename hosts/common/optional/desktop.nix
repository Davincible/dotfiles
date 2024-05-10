{ lib, pkgs, ... }: {
  imports = [
    ./pipewire.nix
  ];

  services = {
    # Enable CUPS to print documents.
    printing.enable = lib.mkDefault true;

    # Enable touchpad support (enabled by default in most desktopManager).
    libinput.enable = lib.mkDefault true;

    # Fingerprint Sensor
    fprintd.enable = lib.mkDefault false;
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
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
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
      setLdLibraryPath = true;
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

    # Browsers
    firefox

    # Desktop apps
    wdisplays # arandr for Wayland
    kanshi # autorandr for Wayland
  ];
}
