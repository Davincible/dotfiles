{ pkgs, ... }:
(pkgs.buildGoModule rec {
  name = "gorun";
  version = "1.0";

  # nix-prefetch-github jackielii gorun
  src = pkgs.fetchFromGitHub {
    owner = "jackielii";
    repo = "gorun";
    rev = "eee715eae8bae98e4fa1fe105a60fce12a2c5708"; # You can specify a commit hash or tag here
    sha256 = "sha256-2Z5kz6w8k7Pa2U5/p3BZZC7rM6lRvbYnIVnYrcoCEyU="; # You need to replace this with the actual hash
  };

  vendorHash = null;

  meta = {
    description = "Go run";
    homepage = "https://github.com/jackielii/gorun";
    license = pkgs.lib.licenses.mit;
  };
})
