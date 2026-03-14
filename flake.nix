{
  description = "Olly's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };

    in
    {
      homeConfigurations = {
        work = lib.mkHome "aarch64-darwin" {
          modules = [ ./hosts/work/home.nix ];
        };
      };

      devShells = lib.eachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = [ nixpkgs.legacyPackages.${system}.lua-language-server ];
        };
      });

      formatter = lib.eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      homeManagerModules.default = ./home-manager;
    };
}
