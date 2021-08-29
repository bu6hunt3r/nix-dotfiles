{ config, lib, pkgs, ... }:

let
  inherit (import ../variables.nix) nixosConfigDir mainUser;

  p14s-backlight-inc = pkgs.writeShellScriptBin "backlight-increase" ''
    brightnessctl s +10% && dunstify -r 6661 'increased brightness'
  '';

  p14s-backlight-dec = pkgs.writeShellScriptBin "backlight-decrease" ''
    brightnessctl s -10% && dunstify -r 6661 'decreased brightness'
  '';

in
{

  virtualisation.docker.enable = true;

  services = {
    #Login prompt
    getty.helpLine = "If you're not cr0c0, Please leave this computer alone";

    blueman.enable = true;

   acpid.handlers = {
     "p14bl-inc" = {
       action =  "${p14s-backlight-inc}/bin/backlight-increase";
       event =  "video/brightnessup BRTUP 00000086 00000000";
     };
     "p14bl-dec" = {
       action = "${p14s-backlight-dec}/bin/backlight-decrease";
       event = "video/brightnessdown BRTDN 00000087 00000000";
     };
   };

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
    #smartcard daemon
    pcscd.enable = true;
    # Power saving
    thermald.enable = true;
  };
}
