{ config, lib, pkgs, ... }:

let
  inherit (import ../variables.nix) nixosConfigDir mainUser;
in
{
  services = {
    #Login prompt
    getty.helpLine = "If you're not cr0c0, Please leave this computer alone";

    xserver = {
      windowManager.i3 = {
        enable = true;
        #configFile=/home/cr0c0/.config/bspwm/bspwmrc;
        #sxhkd.configFile=/home/cr0c0/.config/sxhkdrc;
        package = pkgs.i3-gaps;
      };
      displayManager.startx.enable = true;
      layout = "de";
      #xkbOptions = "caps:swapescape";
      libinput = {
        enable = true;
      };
      extraConfig = ''
        Section "InputClass"
          Identifier "touchpad"
          Driver "libinput"
          MatchIsTouchpad "on"
          Option "NaturalScrolling" "true"
        EndSection
      '';
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
    #find files quickly
    locate.enable = true;
    # Power saving
    thermald.enable = true;
  };
}
