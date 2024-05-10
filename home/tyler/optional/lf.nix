{ inputs, pkgs, ... }:
{
  xdg.desktopEntries = {
    "lf" = {
      name = "lf";
      noDisplay = true;
    };
  };

  home.packages = with pkgs; [
    glib
    fzf
    bat
    zip
    unzip
    gnutar
    pistol
    file
    (callPackage ./gorun.nix { inherit pkgs; })
  ];

  programs.lf = {
    enable = true;

    previewer.source = "${inputs.lf-config}/.config/lf/preview.go";

    settings = {
      cleaner = "${inputs.lf-config}/.config/lf/preview.go";
    };

    commands =
      let
        trash = ''
          ''${{
            set -f
            gio trash $fx
          }}
        '';
      in
      {
        trash = trash;
        delete = trash;
        dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';

        previewer = ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5
        
          if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
              ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
              exit 1
          fi
        
          ${pkgs.pistol}/bin/pistol "$file"
        '';

        open = ''
          ''${{
            case $(file --mime-type -Lb $f) in
                text/*) lf -remote "send $id \$$EDITOR \$fx";;
                *) for f in $fx; do $OPENER "$f" > /dev/null 2> /dev/null & done;;
            esac
          }}
        '';

        fzf = ''
          ''${{
            res="$(find . -maxdepth 1 | fzf --reverse --header='Jump to location')"
            if [ -n "$res" ]; then
                if [ -d "$res" ]; then
                    cmd="cd"
                else
                    cmd="select"
                fi
                res="$(printf '%s' "$res" | sed 's/\\/\\\\/g;s/"/\\"/g')"
                lf -remote "send $id $cmd \"$res\""
            fi
          }}
        '';

        unzip = ''
          ''${{
            set -f
            case $f in
                *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
                *.tar.gz|*.tgz) tar xzvf $f;;
                *.tar.xz|*.txz) tar xJvf $f;;
                *.zip) unzip $f;;
                *.rar) unzip x $f;;
                *.7z) 7z x $f;;
            esac
          }}
        '';

        zip = ''
          ''${{
            set -f
            mkdir $1
            cp -r $fx $1
            zip -r $1.zip $1
            rm -rf $1
          }}
        '';

        pager = ''
          bat --paging=always "$f"
        '';

        on-select = ''
          &{{
            lf -remote "send $id set statfmt \"$(eza -ld --color=always "$f")\""
          }}
        '';

        q = "quit";
      };

    keybindings = {
      a = "push %mkdir<space>";
      t = "push %touch<space>";
      r = "push :rename<space>";
      x = "trash";
      "." = "set hidden!";
      "<delete>" = "trash";
      "<enter>" = "open";
      V = "pager";
      f = "fzf";
      ee = "editor-open";
    };

    settings = {
      scrolloff = 4;
      hidden = true;
      ignorecase = true;
      preview = true;
      drawbox = true;
      icons = true;
      cursorpreviewfmt = "";
    };
  };

  xdg.configFile."lf/icons".source = "${inputs.lf-icons}/etc/icons.example";
}
