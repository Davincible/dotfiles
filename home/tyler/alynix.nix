{
  imports = [
    #################### Required Configs ####################
    ./core #required

    #################### Host-specific Optional Configs ####################
    ./optional/desktops
    ./optional/browsers/chromium.nix
    # ./optional/kitty.nix
  ];
}
