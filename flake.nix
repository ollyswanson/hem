{
  description = "Olly's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      hosts = [{
        host = "work";
        system = "aarch64-darwin";
        user = "swansono";
      }];

      inherits = {
        inherit nixpkgs home-manager;
        inherit hosts;
      };
    in
    {

      homeConfigurations = import ./hosts inherits;
    };
}

