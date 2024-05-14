# https://github.com/nix-community/home-manager/blob/master/modules/programs/fzf.nix
{ config, lib, ... }:
with lib;
let
  cfg = config.programs.fzf;

  bashIntegration = ''
    source <(fzf --bash)
    # source ${cfg.package}/share/fzf/completion.bash
    # source ${cfg.package}/share/fzf/key-bindings.bash
  '';

  zshIntegration = ''
    source <(fzf --zsh)
    # source ${cfg.package}/share/fzf/completion.zsh
    # source ${cfg.package}/share/fzf/key-bindings.zsh
  '';

  defaultCommand = ''
          fd \
            --follow \
            --hidden \
            --max-depth=8 \
            --exclude .git \
            --exclude .snapshots \
            --exclude node_modules \
            --strip-cwd-prefix
  '';

  changeDirWidgetCommand = defaultCommand + " --type d";
in
{
  programs.fzf = {
    enable = true;

    enableZshIntegration = lib.mkForce false;

    inherit defaultCommand changeDirWidgetCommand;
  };

  # Note, since fzf unconditionally binds C-r we use `mkOrder` to make the
  # initialization show up a bit earlier. This is to make initialization of
  # other history managers, like mcfly or atuin, take precedence.
  programs.bash.initExtra = mkOrder 200 bashIntegration;

  # Note, since fzf unconditionally binds C-r we use `mkOrder` to make the
  # initialization show up a bit earlier. This is to make initialization of
  # other history managers, like mcfly or atuin, take precedence.
  programs.zsh.initExtra = mkOrder 200 zshIntegration;
}
