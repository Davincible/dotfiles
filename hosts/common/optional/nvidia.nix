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

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # TODO: Enable in the future
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    #
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "535.154.05";
      sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
      sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
      openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
      settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
      persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
    };

    # forceFullCompositionPipeline = true;

    powerManagement.enable = true;

    # nvidiaPersistenced = true;

    prime = {
      # PRIME Sync - battery heavier, but better performance
      # 
      # Enabling PRIME sync introduces better performance and greatly reduces 
      # screen tearing, at the expense of higher power consumption since the 
      # Nvidia GPU will not go to sleep completely unless called for, as is the 
      # case in Offload Mode. It may also cause its own issues in rare cases. 
      # PRIME Sync and Offload Mode cannot be enabled at the same time.
      # 
      # PRIME sync may also solve some issues with connecting a display in 
      # clamshell mode directly to the GPU.
      sync.enable = true;

      # Reverse PRIME Sync - Only available > ~460.39
      #
      # It ensures that the frame rendered by the discrete NVIDIA GPU is 
      # synchronized with the refresh rate of the display, which is managed by 
      # the integrated GPU. Essentially, it allows the NVIDIA GPU to be aware of 
      # when the integrated GPU's display is refreshing, syncing the frame 
      # transfer to these refresh cycles. This reduces or eliminates screen 
      # tearing, providing a smoother visual experience.
      #
      # TODO: Enable / test again after nvidia kernel panics are resolved
      reverseSync.enable = false;

      # Offload mode only enabled the Nvidia GPU when explicitly called with
      # nvidia-offload. This is more energy efficient, but can cause troubles
      # with external displays.
      # 
      # Offload mode puts your Nvidia GPU to sleep and lets the Intel GPU handle 
      # all tasks, except if you call the Nvidia GPU specifically by "offloading" 
      # an application to it. For example, you can run your laptop normally and 
      # it will use the energy-efficient Intel GPU all day, and then you can 
      # offload a game from Steam onto the Nvidia GPU to make the Nvidia GPU 
      # run that game only. For many, this is the most desirable option.
      offload = {
        enable = false;
        enableOffloadCmd = false;
      };

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
