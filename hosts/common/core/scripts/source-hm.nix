{ config, pkgs, ... }:

let
  myScript = pkgs.writeShellApplication {
    name = "source-hm";
    text = ''
        FILES=(
            "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
            "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh"
            "/etc/profiles/per-user/tyler/etc/profile.d/hm-session-vars.sh"
        )

        echo "SOURCINGGGGGG"
        
        for file in "${FILES[@]}"; do
            if [ -f "$file" ]; then
                echo "Sourcing: $file"
                source "$file"
            else
                echo "File does not exist: $file"
            fi
        done
      '';
    };
in {
  environment.systemPackages = [
    myScript
  ];
}
