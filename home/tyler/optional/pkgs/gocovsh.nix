{ pkgs, ... }:
(pkgs.buildGoModule rec {
  name = "gocovsh";
  version = "1.0";

  # nix-prefetch-github orlangure gocovsh
  src = pkgs.fetchFromGitHub {
    "owner" = "orlangure";
    "repo"= "gocovsh";
    "rev"= "8880bc63283c13a1d630ce3817c7165a6c210d46";
    "hash"= "sha256-0BiJaIpjMe+Jpb+HDC6/axi0LMcBCcpLxbtiWQlxkYY=";
  };

  vendorHash = null;

  meta = {
    description = "Go Coverage Report in Shell";
    homepage = "https://github.com/orlangure/gocovsh";
    license = pkgs.lib.licenses.mit;
  };
})
