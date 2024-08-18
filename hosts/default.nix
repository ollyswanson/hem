{
  hosts,
  nixpkgs,
  home-manager,
  ...
}:
let
  mkHost =
    {
      host,
      system,
      user,
    }:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home.nix
        ./${host}/home.nix
      ];
    };
in
builtins.listToAttrs (
  map (
    mInput@{ host, ... }:
    {
      name = host;
      value = mkHost mInput;
    }
  ) hosts
)
