{ config, lib, pkgs, ... }:

{
  imports = [
    ./system/hardware.nix
    ./system/general-options.nix
    ./system/packages.nix
    ./system/services.nix
    ./system/fonts.nix
    ./users/users.nix
  ];
 
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  system.stateVersion = "21.05";
  nix.gc.automatic = true;
  nix.gc.dates = "18:00";
}
