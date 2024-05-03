{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    kernelParams = [
      "acpi_backlight=native"
      # "module_blacklist=i915" 
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 12;
    };

    initrd = {
      kernelModules = [ ];
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];

      secrets = {
        "/crypto_keyfile.bin" = null;
      };

      luks.devices."luks-f27560cf-e8c8-4c16-bd89-a12ea17fd812".device = "/dev/disk/by-uuid/f27560cf-e8c8-4c16-bd89-a12ea17fd812";
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/01E2-E38F";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-uuid/63d6ee3a-8b82-4282-8b0c-c14697f03d8b";
      fsType = "btrfs";
      options = [ "subvol=@" "defaults" "noatime" "autodefrag" "compress=zstd" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/d8e89652-0492-47b2-9d28-99ea9798a164";
      fsType = "btrfs";
      options = [ "subvol=@home" "defaults" "noatime" "autodefrag" "compress=zstd" ];
    };

    "/var/lib/docker" = {
      device = "/dev/disk/by-uuid/660a7e30-51da-4d42-b347-b46d7a5c6722";
      fsType = "ext4";
      options = [ "rw" "relatime" "discard" ];
    };

    "/media/0x02" = {
      device = "/dev/disk/by-uuid/01D5C80C55CD5360";
      fsType = "ntfs-3g";
      options = [ "rw" "auto" "user" "fmask=133" "dmask=022" "uid=1000" "gid=1000" "nofail" ];
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "ondemand";

    # Enable PowerTop autotune on startup
    powertop = {
      enable = true;
    };
  };

  hardware = {
    nvidia = {
      prime = {
        # Bus ID of the Intel GPU.
        intelBusId = "PCI:0:2:0";

        # Bus ID of the NVIDIA GPU.
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  swapDevices = [ ];
}
