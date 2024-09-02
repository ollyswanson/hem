{
  description = "Monlith dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          nativeBuildInputs = with pkgs; [ python39 poetry pyright libffi ruff ];
        in
        {
          devShells.default = pkgs.mkShell {
            inherit nativeBuildInputs;
          };
        }
      );
}
