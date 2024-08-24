{ lib, ... }: {
  networking = {
    # Enable networking
    networkmanager.enable = true;

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "9.9.9.9"
    ];
  };
}
