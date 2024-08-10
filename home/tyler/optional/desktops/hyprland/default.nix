# TODO: scratchpads https://www.youtube.com/watch?v=CwGlm-rpok4
# Setup flameshot: https://github.com/flameshot-org/flameshot/issues/2978
# Multimonitor workspaces: https://github.com/sopa0/hyprsome
#
# https://github.com/HeinzDev/Hyprland-dotfiles/blob/main/home/programs/hypr/default.nix
# https://github.com/hyprland-community/awesome-hyprland#runners-menus-and-application-launchers
# https://github.com/Aylur/dotfiles
{ inputs, lib, pkgs, ... }:
let
  # startup = configLib.makeScriptPkg ./scripts/start.sh;
  hyprlandSrc = inputs.hyprland.packages."${pkgs.system}";
  hyprlandScannerSrc = inputs.hyprlandScanner.packages."${pkgs.system}";
in
{
  imports = [
    # custom key binds
    ./binds.nix
    ../ags
  ];

  services.gammastep = {
    enable = true;
    # brightness = {
    #   day = "1";
    #   night = "1";
    # };
    temperature = {
      day = 5700;
      night = 2500;
    };
    provider = "geoclue2";
    dawnTime = "07:00-08:00";
    duskTime = "19:00-20:00";
    tray = true;
    settings = {
      redshift = {
        gamma = 0.8;
        fade = 1;
      };
    };
  };

  home.packages = with pkgs; [
    playerctl
    swww # Desktop wallpaper daemon
    cliphist # Clipboard history
    libnotify # Desktop notifications daemon
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    hyprlandSrc.xdg-desktop-portal-hyprland
    networkmanagerapplet
    rofi-wayland
    gnome.adwaita-icon-theme
    swayidle
    grim
    slurp
    swappy
    bluez
    catppuccin-cursors
    catppuccin-cursors.mochaSky
    hyprcursor

    # TODO: setup after deleting gnome
    # polkit-kde-agent
  ] ++ [
    # hyprlandScannerSrc.hyprwayland-scanner
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
    package = hyprlandSrc.hyprland;
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

      cursor = {
        no_hardware_cursors = true;
      };

      # load at the end of the hyperland set
      # extraConfig = ''    '';

      # exec-once = "${startup}/bin/start";

      exec-once = [
        "ags -b hypr"
        # "hyprctl setcursor Qogir 24"
      ];

      monitor = [ ",preferred,auto,1" ];

      plugin = {
        overview = {
          centerAligned = true;
          hideTopLayers = true;
          hideOverlayLayers = true;
          showNewWorkspace = true;
          exitOnClick = true;
          exitOnSwitch = true;
          drawActiveWorkspace = true;
          reverseSwipe = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];

        # animation = [
        #   "fadeIn,0"
        #   "fadeOut,0"
        #   "windowsIn,0"
        #   "windowsOut,0"
        # ];
      };

      general = {
        gaps_in = 8;
        gaps_out = 5;
        border_size = 1;
        # # Gaps and border
        # gaps_in = 4
        # gaps_out = 5
        # gaps_workspaces = 50

        # Fallback colors
        "col.active_border" = "rgba(0DB7D4FF)";
        "col.inactive_border" = "rgba(31313600)";

        resize_on_border = true;
        no_focus_fallback = true;
        layout = "dwindle";

        #focus_to_other_workspaces = true # ahhhh i still haven't properly implemented this
        allow_tearing = true; # This just allows the `immediate` window rule to work
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
        # no_gaps_when_only = "yes";
      };

      decoration = {
        # enabled = false;
        active_opacity = 0.94;
        inactive_opacity = 0.87;
        fullscreen_opacity = 1.0;
        rounding = 8;

        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          popups = true;
        };

        #   drop_shadow = false;
        # shadow_range = 12;
        # shadow_offset = "3 3";
        # "col.shadow" = "0x44000000";
        # "col.shadow_inactive" = "0x66000000";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
        workspace_swipe_use_r = true;
      };

      input = {
        # Keyboard: Add a layout and uncomment kb_options for Win+Space switching shortcut
        kb_layout = "us";

        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;

        touchpad = {
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.5;
          natural_scroll = true;
        };

        special_fallthrough = true;
        follow_mouse = 1;
      };

      windowrule =
        let
          # A function to create a window rule based on a regular expression
          makeRule = regex: "float, ^(${regex})$";

          # A function that applies multiple rules to a list of selectors
          applyRules = selectors: rules:
            lib.concatMap (selector: map (rule: rule selector) rules) selectors;

          # A function to generate a rule string for a class selector
          classRule = class: "class:${class}";

          # A function to generate a rule string for a title selector
          titleRule = title: "title:${title}";

          applyMultipleRules = selector: rules: map (rule: "${rule}, ${selector}") rules;

          # List of class selectors to float
          classesToFLoat = [
            "org.gnome.Calculator"
            "org.gnome.Nautilus"
            "pavucontrol"
            "nm-connection-editor"
            "blueberry.py"
            "org.gnome.Settings"
            "org.gnome.design.Palette"
            "Color Picker"
            "xdg-desktop-portal"
            "xdg-desktop-portal-gnome"
            "transmission-gtk"
            "com.github.Aylur.ags"
          ];

          # Special rules for specific titles
          specialRules = [
            {
              selector = titleRule "Bitwarden - Opera";
              rules = [
                "float"
                "noborder"
                "nodim"
                "opaque"
              ];
            }
            {
              selector = titleRule "Picture in Picture";
              rules = [
                "float"
                "opaque"
                "nodim"
                "noborder"
                "move 100%-w-20"
                "pin"
              ];
            }
            { selector = titleRule "Spotify"; rules = [ "workspace 7" ]; }
          ];
        in
        {
          windowrule =
            lib.concatLists [
              (applyRules (map classRule classesToFLoat) [ makeRule ])
              (lib.concatMap ({ selector, rules }: applyMultipleRules selector rules) specialRules)
            ];
        };

      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        # "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        # "MOZ_WEBRENDER, 1" # for firefox to run on wayland

        "WLR_RENDERER_ALLOW_SOFTWARE,1"

        # "QT_QPA_PLATFORM,wayland"

        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        # "WLR_NO_HARDWARE_CURSORS,1" # Can try to disable for hardware cursor
        "HYPRCURSOR_THEME,Catppuccin-Mocha-Sky"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,Catppuccin-Mocha-Sky"
        "XCURSOR_SIZE,24"
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
