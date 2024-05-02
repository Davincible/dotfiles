# smb.nix
{ config, lib, ... }:

{
  fileSystems =
    let
      smbShares = config.sops.secrets.sops-secrets.secrets.smb;
    in
    lib.genAttrs (map (s: s.mount) smbShares) (smb: {
      device = "//${smb.ip}/${smb.share}";
      fsType = "cifs";
      options = [
        "auto"
        "vers=3.0"
        "user=${smb.user}"
        "pass=${smb.pass}"
        "uid=1000"
        "gid=1000"
        "nofail"
      ];
    });
}

