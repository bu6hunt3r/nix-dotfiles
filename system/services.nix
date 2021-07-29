{ config, lib, pkgs, ... }:

let
  inherit (import ../variables.nix) nixosConfigDir mainUser;
in
{
  services = {
    #Login prompt
    getty.helpLine = "If you're not Iheb, Please leave this computer alone";

    xserver = {
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      displayManager.startx.enable = true;
      layout = "de";
      xkbOptions = "caps:swapescape";
    };

    #brightness control
    #illum.enable = true;

    autorandr.enable = true;

    # Maybe this one day will be useful
    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = with pkgs; [ gutenprint ];

    #for scripts running in the background
    cron.enable = true;
  };

}
