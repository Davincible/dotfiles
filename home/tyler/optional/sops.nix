# home level sops. see hosts/common/optional/sops.nix for hosts level
{ inputs, config, ... }:
let
  secretsDirectory = builtins.toString inputs.nix-secrets;
  secretsFile = "${secretsDirectory}/user-secrets.yaml";
  homeDirectory = config.home.homeDirectory;
  addSshKeys = config.hostConfig.addSshKeys;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # This is the ta/dev key and needs to have been copied to this location on the host
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";

    # defaultSopsFile = "${secretsFile}";
    # validateSopsFiles = false;

    secrets = lib.mkMerge [
      # {
      #   "ssh_keys/${config.networking.hostName}/private" = {
      #     path = "${homeDirectory}/.ssh/id_ed25519";
      #   };
      #   "ssh_keys/${config.networking.hostName}/public" = {
      #     path = "${homeDirectory}/.ssh/id_ed25519.pub";
      #   };
      # }
      # TODO: add ssh key from config file
      # (lib.optionalAttrs addSshKeys {
      #   "some_conditional_secret" = {
      #     path = "${homeDirectory}/.ssh/some_conditional_secret";
      #   };
      # })
    ]
      };
  }
