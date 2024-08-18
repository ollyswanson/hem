{
  description = "Olly's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };

      secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
    in
    {
      homeConfigurations = {
        orbstack = lib.mkHome "aarch64-linux" {
          modules = [ ./hosts/orbstack/home.nix ];
          extraSpecialArgs = {
            inherit secrets;
          };
        };
        work = lib.mkHome "aarch64-darwin" {
          modules = [ ./hosts/work/home.nix ];
          extraSpecialArgs = {
            inherit secrets;
          };
        };
      };

      nixosConfigurations = {
        orbstack = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/orbstack/configuration.nix ];
        };
      };

      formatter = lib.eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      homeManagerModules.default = ./home-manager;
    };
}
