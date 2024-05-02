{ lib, pkgs, ... }: {
  imports = [
    ./pipewire.nix
  ];

  services = {
    # Enable CUPS to print documents.
    printing.enable = lib.mkDefault true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = lib.mkDefault true;

    # Fingerprint Sensor
    fprintd.enable = lib.mkDefault true;

  };

  # Emulate mouse wheel on trackpoint
  # hardware.trackpoint.emulateWheel = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
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
