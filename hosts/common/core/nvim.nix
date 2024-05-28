{ pkgs, inputs, ... }: {
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  # };

  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  environment.systemPackages = with pkgs; [
    python3
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    # package = pkgs.neovim;

    # colorschemes.gruvbox.enable = true;
    # plugins.lightline.enable = true;
  };
}
