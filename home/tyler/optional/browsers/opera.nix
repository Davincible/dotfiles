{ pkgs, ... }:
let
  runOpera = pkgs.writeScript "run-opera" ''
    #!/bin/sh
    LD_LIBRARY_PATH="\\$LD_LIBRARY_PATH:${pkgs.libGL}/lib:${pkgs.ffmpeg}/lib" exec ${pkgs.opera}/bin/opera "$@"
  '';
in
{
  home.packages = with pkgs; [
    (opera.override { proprietaryCodecs = true; })
  ];

  xdg.desktopEntries.opera = {
    name = "Opera";
    genericName = "Web browser";
    comment = "Fast and secure web browser";
    exec = "${runOpera} %U";
    terminal = false;
    icon = "opera";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml_xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "application/x-opera-download"
    ];
    actions = {
      "new-window" = {
        name = "New Window";
        exec = "${runOpera} --new-window";
      };
      "new-private-window" = {
        name = "New Private Window";
        exec = "${runOpera} --incognito";
      };
    };
  };
}
