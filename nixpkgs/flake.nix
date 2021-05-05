{
  description = "Example home-manager from non-nixos system";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  # inputs.nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

  inputs.emacs-overlay = {
    type = "github";
    owner = "mjlbach";
    repo = "emacs-overlay";
    rev = "d62b49ac651e314080e333a7e1f190877675ee99";
    # url = "path:/Users/michae/Repositories/emacs-overlay";
    ref = "feature/flakes";
  };

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    # url = "path:/Users/michael/Repositories/nix/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.LS_COLORS = {
    url = "github:trapd00r/LS_COLORS";
    flake = false;
  };

  outputs = { self, ... }@inputs:
    let
      # nixos-unstable-overlay = final: prev: {
      #   nixos-unstable = import inputs.nixos-unstable {
      #     system = prev.system;
      #     # config.allowUnfree = true;
      #     overlays = [ inputs.emacs-overlay.overlay ];
      #   };
      # };
      overlays = [
        # nixos-unstable-overlay
        inputs.emacs-overlay.overlay
        inputs.neovim-nightly-overlay.overlay
        (final: prev: { LS_COLORS = inputs.LS_COLORS; })
      ];
    in
    {
      homeConfigurations = {
        nixos-desktop = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }:
            {
              xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
              nixpkgs.config = import ./configs/nix/config.nix;
              nixpkgs.overlays = overlays;
              imports = [
                ./modules/home-manager.nix
                ./modules/alacritty.nix
                ./modules/chat.nix
                ./modules/cli.nix
                # ./modules/cuda.nix
                ./modules/git.nix
                ./modules/media.nix
                ./modules/nix-utilities.nix
                ./modules/nixos-desktop.nix
                ./modules/python.nix
                ./modules/ssh.nix
                ./modules/languages.nix
                ./modules/linux-only.nix
                ./modules/neovim.nix
              ];
              programs.zsh.initExtra = builtins.readFile ./configs/zsh/nixos-desktop_zshrc.zsh;
            };
          system = "x86_64-linux";
          homeDirectory = "/home/cr0c0";
          username = "cr0c0";
        };
      };
      nixos-desktop = self.homeConfigurations.nixos-desktop.activationPackage;
    };
}
