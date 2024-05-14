{ pkgs, ... }: {
  home.packages = with pkgs; [
    (callPackage ./gorun.nix { inherit pkgs; })
    (callPackage ./gocovsh.nix { inherit pkgs; })
  ];

}
