{
  imports = [
    #################### Required Configs ####################
    ./core #required

    #################### Host-specific Optional Configs ####################
    ./optional/desktops
    ./optional/pkgs
    ./optional/browsers/chromium.nix
    ./optional/browsers/opera.nix
    ./optional/lf.nix
    # ./optional/kitty.nix
  ];
}
