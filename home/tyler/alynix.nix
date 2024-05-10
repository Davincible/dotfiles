{
  imports = [
    #################### Required Configs ####################
    ./core #required

    #################### Host-specific Optional Configs ####################
    ./optional/desktops
    ./optional/browsers/chromium.nix
    ./optional/lf.nix
    # ./optional/kitty.nix
  ];
}
