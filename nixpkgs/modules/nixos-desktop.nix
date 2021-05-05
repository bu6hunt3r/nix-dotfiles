{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [
    ark
    bitwarden
    exercism
    firefox
    gnome3.geary
    graphviz
    gwenview
    # libreoffice-qt
    (nerdfonts.override { fonts = [ "Meslo" ]; })
    okular
    openssh
    simplescreenrecorder
    spectacle
    spotify
    # unityhub
    wireguard-tools
    zgrviewer
  ];
}
