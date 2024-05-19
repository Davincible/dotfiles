{ pkgs, lib, ... }:
(pkgs.buildGoModule rec {
  name = "gocovsh";
  version = "1.0";

  # nix-prefetch-github orlangure gocovsh
  src = pkgs.fetchFromGitHub {
    "owner" = "orlangure";
    "repo" = "gocovsh";
    "rev" = "8880bc63283c13a1d630ce3817c7165a6c210d46";
    "hash" = "sha256-0BiJaIpjMe+Jpb+HDC6/axi0LMcBCcpLxbtiWQlxkYY=";
  };

  # NOTE: to get the real hash, specify a wrong hash, then the build step will give you the correct hash.
  vendorHash = "sha256-Fb7BIWojOSUIlBdjIt57CSvF1a+x33sB45Z0a86JMUg=";

  meta = {
    description = "Go Coverage Report in Shell";
    homepage = "https://github.com/orlangure/gocovsh";
    license = pkgs.lib.licenses.mit;
  };
})
