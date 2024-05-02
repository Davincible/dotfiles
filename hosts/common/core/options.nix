{ lib, ... }:

{
  options = {
    hostConfig = {
      addSshKeys = lib.mkOption {
        type = lib.types.str;
        default = false;
        description = "Whether or not to add the SSH keys from the sop secrets";
      };

      # TODO: add other options here, e.g. which optional files to include
    };
  };
}
