{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.05;
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = github:nix-community/home-manager/release-23.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }
  :
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [ self.overlays.default ];
    };
  in {
    nixosConfigurations.sus = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      # specialArgs = attrs;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ted = import ./home.nix;
          };
        }
      ];
    };
    overlays.default = final: prev: {
      unstable = import nixpkgs-unstable {
        config = {
          allowUnfree = true;
        };
        localSystem = { inherit system; };
      };
    };
  };
}
