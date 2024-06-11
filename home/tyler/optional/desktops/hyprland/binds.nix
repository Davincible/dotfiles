{ pkgs, lib, ... }:
let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  swappy = "${pkgs.swappy}/bin/swappy";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      binds = {
        # focus_window_on_workspace_c# For Auto-run stuff see execs.confhange = true
        scroll_event_delay = 0;
        allow_workspace_cycles = true;
      };

      bindm = [
        "SUPER,mouse:272,movewindow"
        # "SUPER,mouse:273,resizewindow"
      ];

      bindle = [
        ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
        ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
        ",XF86KbdBrightnessUp,   exec, ${brightnessctl} -d asus::kbd_backlight set +1"
        ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight set  1-"
        ",XF86AudioRaiseVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      ];

      bindl = [
        ",XF86AudioPlay,    exec, ${playerctl} play-pause"
        ",XF86AudioStop,    exec, ${playerctl} pause"
        ",XF86AudioPause,   exec, ${playerctl} pause"
        ",XF86AudioPrev,    exec, ${playerctl} previous"
        ",XF86AudioNext,    exec, ${playerctl} next"
        ",XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        '',XF86Launch2,      exec, ${grim} -g "$(${slurp})" - | ${swappy} -f -''
        '',Print,      exec, ${grim} -g "$(${slurp})" - | ${swappy} -f -''
      ];


      bind =
        let
          workspaces = [
            "0"
            "1"
            "2"
            "3"
            "4"
            "5"
            "6"
            "7"
            "8"
            "9"
            "F1"
            "F2"
            "F3"
            "F4"
            "F5"
            "F6"
            "F7"
            "F8"
            "F9"
            "F10"
            "F11"
            "F12"
          ];

          # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
          directions = rec {
            left = "l";
            right = "r";
            up = "u";
            down = "d";
            h = left;
            l = right;
            k = up;
            j = down;
          };

          #swaylock = "${config.programs.swaylock.package}/bin/swaylock";
          #playerctl = "${config.services.playerctld.package}/bin/playerctl";
          #playerctld = "${config.services.playerctld.package}/bin/playerctld";
          #makoctl = "${config.services.mako.package}/bin/makoctl";
          #wofi = "${config.programs.wofi.package}/bin/wofi";
          #pass-wofi = "${pkgs.pass-wofi.override {
          #pass = config.programs.password-store.package;
          #}}/bin/pass-wofi";

          #grimblast = "${pkgs.inputs.hyprwm-contrib.grimblast}/bin/grimblast";
          #pactl = "${pkgs.pulseaudio}/bin/pactl";
          #tly = "${pkgs.tly}/bin/tly";
          #gtk-play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
          #notify-send = "${pkgs.libnotify}/bin/notify-send";

          #gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
          #xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
          #defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

          #terminal = config.home.sessionVariables.TERM;
          #browser = defaultApp "x-scheme-handler/https";
          #editor = defaultApp "text/plain";
        in
        [
          #################### Program Launch ####################
          "SUPER,Return,exec,kitty"
          "ALT,space,exec,rofi -show drun"

          #################### Basic Bindings ####################
          "SHIFTALT,q,killactive"
          "SUPERSHIFT,e,exit"
          "CTRLSHIFT,R,exec,ags -b hypr quit; ags -b hypr"

          "SUPER,s,togglesplit"
          "SUPER,f,fullscreen,1"
          "SUPERSHIFT,f,fullscreen,0"
          "ALT,f,fakefullscreen"
          "SUPERSHIFT,space,togglefloating"

          "SUPER,minus,splitratio,-0.25"
          "SUPERSHIFT,minus,splitratio,-0.3333333"

          "SUPER,equal,splitratio,0.25"
          "SUPERSHIFT,equal,splitratio,0.3333333"

          "SUPER,g,togglegroup"
          "SUPER,t,lockactivegroup,toggle"
          "SUPER,apostrophe,changegroupactive,f"
          "SUPERSHIFT,apostrophe,changegroupactive,b"

          "SUPER,u,togglespecialworkspace"
          "SUPERSHIFT,u,movetoworkspacesilent,special"
          "SUPERSHIFT,l,movetoworkspacesilent,+1"
          "SUPERSHIFT,right,movetoworkspacesilent,+1"
          "SUPERSHIFT,h,movetoworkspacesilent,-1"
          "SUPERSHIFT,left,movetoworkspacesilent,-1"
        ] ++

        # Change workspace
        (map
          (n:
            "SUPER,${n},workspace,name:${n}"
          )
          workspaces) ++

        # Move window to workspace
        (map
          (n:
            "SHIFTALT,${n},movetoworkspacesilent,name:${n}"
          )
          workspaces) ++

        # Move focus
        (lib.mapAttrsToList
          (key: direction:
            "ALT,${key},movefocus,${direction}"
          )
          directions) ++

        # Swap windows
        (lib.mapAttrsToList
          (key: direction:
            "SUPERSHIFT,${key},swapwindow,${direction}"
          )
          directions) ++

        # Move windows
        (lib.mapAttrsToList
          (key: direction:
            "SHIFTALT,${key},movewindoworgroup,${direction}"
          )
          directions) ++

        # Move monitor focus
        (lib.mapAttrsToList
          (key: direction:
            "SUPERALT,${key},focusmonitor,${direction}"
          )
          directions) ++

        # Move workspace to other monitor
        (lib.mapAttrsToList
          (key: direction:
            "SUPERALTSHIFT,${key},movecurrentworkspacetomonitor,${direction}"
          )
          directions);
    };
  };
}
