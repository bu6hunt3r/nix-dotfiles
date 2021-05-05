{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [
    vlc
    gimp
  ];
}
