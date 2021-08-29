{ config, lib, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      inconsolata
      font-awesome_4
      font-awesome-ttf
      freefont_ttf
      terminus_font
      corefonts
      dejavu_fonts
      iosevka
      jetbrains-mono
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro
      libertinus
      libertine
      profont
      liberation_ttf
      (import (fetchgit {
         url = git://github.com/spearman/ibm3270font-nix.git;
         rev = "bbeae02abb08a20eac7256e6e3c85eb7073897a4";
         sha256 = "0gss85kvlwzky4354hmzjj7jfs1m6fv3wly4v9rnipmqss7jkcjq";
      }))
    ];
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Linux Libertine" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Inconsolata" "FontAwesome" ];
      };
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>
          <alias>
            <family>sans</family>
            <prefer><family>DejaVu Sans</family></prefer>
          </alias>
        </fontconfig>
      '';
      includeUserConf=false;
    };
  };
}
