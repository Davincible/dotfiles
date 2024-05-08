# Example: https://github.com/HeinzDev/Hyprland-dotfiles/blob/main/home/programs/kitty/default.nix
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    # window_padding_width 32 32 0 32
    # tab_separator " | "

  };
}
