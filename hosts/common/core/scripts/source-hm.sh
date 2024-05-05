# This script loads all home manager environment variables
# options: none
FILES=(
    "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    "$HOME/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh"
    "/etc/profiles/per-user/tyler/etc/profile.d/hm-session-vars.sh"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done
