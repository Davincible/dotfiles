{ inputs
, pkgs
, ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.astal.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bun
    dart-sass
    brightnessctl
    inputs.matugen.packages.${system}.default
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];

  programs.astal = {
    enable = true;
    extraPackages = with pkgs; [
      libadwaita
    ];
  };

  programs.ags = {
    enable = true;
    configDir = ./src;
    extraPackages = with pkgs; [
      accountsservice
    ];
  };
}
