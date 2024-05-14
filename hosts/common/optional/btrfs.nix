{ pkgs, ... }:
let
  notifyScript = pkgs.writeScriptBin "notify-btrfs-task" ''
    #! ${pkgs.stdenv.shell}
    exec >&2
    echo "$1: $2 started at $(date)"
    START_TIME=$SECONDS
    if $2; then
      ELAPSED_TIME=$(($SECONDS - $START_TIME))
      echo "$1: $2 completed successfully in $ELAPSED_TIME seconds."
    else
      echo "$1: $2 failed."
    fi
  '';
in
{
  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

  services.btrfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [
        "/"
        "/home"
      ];
    };
  };

  systemd.services = {
    btrfs-scrub = {
      description = "Btrfs scrub / and /home";
      script = ''
        ${notifyScript}/bin/notify-btrfs-task Scrub "btrfs scrub start / && btrfs scrub start /home"
      '';
      serviceConfig.Type = "oneshot";
    };

    btrfs-balance = {
      description = "Btrfs balance / and /home";
      script = ''
        ${notifyScript}/bin/notify-btrfs-task Balance "btrfs balance start / && btrfs balance start /home"
      '';
      serviceConfig.Type = "oneshot";
    };
  };

  systemd.timers = {
    # btrfs-scrub = {
    #   wantedBy = [ "timers.target" ];
    #   timerConfig = {
    #     OnCalendar = "weekly";
    #     Persistent = true;
    #   };
    # };

    btrfs-balance = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly:1/2"; # Every two weeks
        Persistent = true;
      };
    };
  };

}
