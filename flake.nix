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
      hosts = [
        {
          host = "work";
          system = "aarch64-darwin";
          user = "swansono";
        }
      ];

      inherits = {
        inherit nixpkgs home-manager;
        inherit hosts;
      };

      secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
    in
    {
      homeConfigurations = {
        orbstack = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [ ./hosts/home.nix ];
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
    };
}
