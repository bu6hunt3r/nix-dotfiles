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

  system.stateVersion = "21.11";
  nix.gc.automatic = true;
  nix.gc.dates = "18:00";
}
