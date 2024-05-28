# https://github.com/sharkdp/bat
# https://github.com/eth-p/bat-extras

{ pkgs, ... }: {
  programs = {
    zsh = {
      shellAliases = {
        cat = "bat";
        diff = "batdiff";
        rg = "batgrep";
        man = "batman";
        watch = "batwatch";
      };
    };

    bat = {
      enable = true;

      config = {
        # Show line numbers, Git modifications and file header (but no grid)
        style = "numbers,changes,header";
        theme = "gruvbox-dark";
      };

      extraPackages = with pkgs; [
        entr # Requirement for batwatch
        delta # Requirement for batdiff
        bat-extras.batgrep # search through and highlight files using ripgrep
        bat-extras.batdiff # Diff a file against the current git index, or display the diff between to files
        bat-extras.batwatch # Better watch
        bat-extras.batman # read manpages using bat as the formatter
      ];
    };
  };
}
