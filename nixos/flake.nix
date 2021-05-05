{
  # inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nur.url = github:nix-community/NUR;
  outputs = { self, nixpkgs, nur }: {
    nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        { nixpkgs.overlays = [ nur.overlay ]; }
      ];
    };
  };
}
