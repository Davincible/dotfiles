#
# This is a basic enablement of zsh at the host level as a safe guard
# in case enabling zsh as a home-manager module (see /home/ta/core/cli)
# at the user level fails for some reason.
#

{
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
}
