{ lib, outputs, ... }: {
  nix = {
    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      persistent = true; # Store last time the service ran to disk
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise = {
      automatic = true;
    };
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";

    # you can add global overlays here
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
