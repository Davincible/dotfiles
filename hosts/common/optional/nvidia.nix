{ config, lib, pkgs, ... }: {
  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
    ];

  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # forceFullCompositionPipeline = true;

    powerManagement.enable = true;

    # nvidiaPersistenced = true;

    prime = {
      # sync.enable = true;
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
      reverseSync.enable = true;

      # Bus ID of the Intel GPU.
      intelBusId = lib.mkDefault "0@0:2:0";

      # Bus ID of the NVIDIA GPU.
      nvidiaBusId = lib.mkDefault "1@1:0:0";
    };
  };

  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  # Need to set Thunderbolt to "BIOS Assist Mode"
  # https://forums.lenovo.com/t5/Other-Linux-Discussions/T480-CPU-temperature-and-fan-speed-under-linux/m-p/4114832
  # 
  # 
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  environment.systemPackages = with pkgs; [
    nvidia-podman
  ];
}
