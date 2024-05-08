# TODO: scratchpads https://www.youtube.com/watch?v=CwGlm-rpok4
# Setup flameshot: https://github.com/flameshot-org/flameshot/issues/2978
# Multimonitor workspaces: https://github.com/sopa0/hyprsome
#
# https://github.com/HeinzDev/Hyprland-dotfiles/blob/main/home/programs/hypr/default.nix
# https://github.com/hyprland-community/awesome-hyprland#runners-menus-and-application-launchers
# https://github.com/Aylur/dotfiles
{ inputs, pkgs, configLib, ... }:
let
  # startup = configLib.makeScriptPkg ./scripts/start.sh;
  hyprlandSrc = inputs.hyprland.packages."${pkgs.system}";
in
{
  imports = [
    # custom key binds
    ./binds.nix
  ];

  home.packages = with pkgs; [
    playerctl
    swww # Desktop wallpaper daemon
    cliphist # Clipboard history
    libnotify # Desktop notifications daemon
    xdg-desktop-portal-gtk
    hyprlandSrc.xdg-desktop-portal-hyprland
    networkmanagerapplet

    # TODO: setup after deleting gnome
    # polkit-kde-agent
  ];

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   # x11.enable = true;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Classic";
  #   size = 16;
  # };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # TODO: test this later
      # hyprlandSrc.xdg-desktop-portal-hyprland
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;

    # NOTE: xdg portal package is currently set in /hosts/common/optional/hyprland.nix
    # portalPackage = pkgs.xdg-desktop-portal-hyprland; # default


    # systemd = {
    #   enable = true;
    #   # TODO: experiment with whether this is required.
    #   # Same as default, but stop the graphical session too
    #   extraCommands = lib.mkBefore [
    #     "systemctl --user stop graphical-session.target"
    #     "systemctl --user start hyprland-session.target"
    #   ];
    # };

    # plugins = [];

    settings = {
      "$mod" = "SUPER";

      # load at the end of the hyperland set
      # extraConfig = ''    '';

      # exec-once = "${startup}/bin/start";

      monitor = ",preferred,auto,1";

      general = {
        gaps_in = 8;
        gaps_out = 5;
        border_size = 3;
        cursor_inactive_timeout = 4;
        # # Gaps and border
        # gaps_in = 4
        # gaps_out = 5
        # gaps_workspaces = 50
        # border_size = 1

        # Fallback colors
        "col.active_border" = "rgba(0DB7D4FF)";
        "col.inactive_border" = "rgba(31313600)";

        resize_on_border = true;
        no_focus_fallback = true;
        layout = "dwindle";

        #focus_to_other_workspaces = true # ahhhh i still haven't properly implemented this
        allow_tearing = true; # This just allows the `immediate` window rule to work
      };

      decoration = {
        enabled = false;
        active_opacity = 0.94;
        inactive_opacity = 0.75;
        fullscreen_opacity = 1.0;
        rounding = 8;

        blur = {
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };

        #   drop_shadow = false;
        #   shadow_range = 12;
        #   shadow_offset = "3 3";
        #   "col.shadow" = "0x44000000";
        #   "col.shadow_inactive" = "0x66000000";
      };

      input = {
        # Keyboard: Add a layout and uncomment kb_options for Win+Space switching shortcut
        kb_layout = "us";

        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;
        natural_scroll = true;

        touchpad = {
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.5;
        };

        special_fallthrough = true;
        follow_mouse = 1;
      };

      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        # "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        # "MOZ_WEBRENDER, 1" # for firefox to run on wayland

        "WLR_RENDERER_ALLOW_SOFTWARE,1"

        # "QT_QPA_PLATFORM,wayland"

        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1" # Can try to disable for hardware cursor
        "NVD_BACKEND,direct"
      ];
    };
  };

  # # TODO: move below into individual .nix files with their own configs
  # home.packages = builtins.attrValues {
  #   inherit (pkgs)
  #   nm-applet --indicator &  # notification manager applet.
  #   bar
  #   waybar  # closest thing to polybar available
  #   where is polybar? not supported yet: https://github.com/polybar/polybar/issues/414
  #   eww # alternative - complex at first but can do cool shit apparently
  #
  #   # Wallpaper daemon
  #   hyprpaper
  #   swaybg
  #   wpaperd
  #   mpvpaper
  #   swww # vimjoyer recoomended
  #   nitrogen
  #
  #   # app launcher
  #   rofi-wayland;
  #   wofi # gtk rofi
  # };
}
