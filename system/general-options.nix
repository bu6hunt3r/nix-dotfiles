{ config, lib, pkgs, ... }:

let 
  inherit (import ../variables.nix) nixosConfigDir mainUser;
in
{
  #grub
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.splashImage = ./splashscreen.png;
  
  #networking
  networking.hostName = "faulobst-x1"; #hostname
  networking.networkmanager.enable = true; # networking via networkmanager

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  i18n.defaultLocale = "de_DE.UTF-8";

  #time zone
  time.timeZone = "Europe/Berlin";
  
  documentation.doc.enable = false;
}
