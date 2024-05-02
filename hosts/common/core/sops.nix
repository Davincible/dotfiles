# hosts level sops. see home/[user]/common/optional/sops.nix for home/user level

{ inputs, config, ... }:
let
  secretsDirectory = builtins.toString inputs.nix-secrets;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretsDirectory}/secrets.yaml";

    validateSopsFiles = false;

    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/id_ed25519" ];
      # sshKeyPaths = [ "~/.ssh/id_ed25519" ];
      # this will use an age key that is expected to already be in the filesystem
      # This is the private key derived from the SSH key
      keyFile = "/var/lib/sops-nix/key.txt";
      # keyFile = "~/.config/sops/age/key.txt";
      # generate a new key if the key specified above does not exist
      generateKey = true;
    };

    # secrets will be output to /run/secrets
    # secrets required for user creation are handled in respective ./users/<username>.nix files
    # because they will be output to /run/secrets-for-users and only when the user is assigned to a host.
    secrets = {
      smb = {
        owner = "root";
        group = "wheel";
        mode = "0440";
        path = "/run/secrets/smb-shares.yaml";
      };
    };
  };
}
