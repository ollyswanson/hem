{ inputs }:
let
  inherit (inputs) nixpkgs home-manager;
  inherit (nixpkgs.lib) unique;
  inherit (builtins)
    elemAt
    head
    length
    zipAttrsWith
    isList
    isAttrs
    ;

  outputs = inputs.self.outputs;

  eachSystem =
    f:
    nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ] f;

  pkgsFor = system: nixpkgs.legacyPackages.${system};

  mkHome =
    sys: hostConfig:
    home-manager.lib.homeManagerConfiguration (
      mergeOnce {
        pkgs = pkgsFor sys;
        extraSpecialArgs = {
          inherit hemLib;
        };
        modules = [ outputs.homeManagerModules.default ];
      } hostConfig
    );

  # ```
  # mergeOnce
  #   {
  #     a = { b = 5; c = 10; d = [ 5 6 ]; };
  #   }
  #   {
  #     a = { b = 6; d = [ 5 7 ]; }; e = 10;
  #   }
  # =>
  #   {
  #     a = { b = 6; c = 10; d = [ 5 6 7 ]; }; e = 10;
  #   }
  # ```
  #  The idea is to provide a way to recursively combine attrSets, similarly to
  # `recursiveUpdate`[1] with the difference being that when we encounter
  # `isList lhs && `isList rhs`, instead of simply taking rhs we merge the lists.
  #
  # We _do not_ attempt to merge attrSets in the list that we encounter as doing so is not only
  # complicated, but isn't the functionality we want.
  #
  # [1]: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.attrsets.recursiveUpdate
  mergeOnce =
    lhs: rhs:
    let
      merge =
        lhs: rhs:
        if isList lhs && isList rhs then
          # O(n^2)
          unique (lhs ++ rhs)
        else if isAttrs lhs && isAttrs rhs then
          f [
            lhs
            rhs
          ]
        else
          rhs;
      f = zipAttrsWith (
        n: values: if length values == 1 then head values else merge (head values) (elemAt values 1)
      );
    in
    f [
      lhs
      rhs
    ];

  hemLib = {
    inherit
      eachSystem
      pkgsFor
      mkHome
      mergeOnce
      ;
  };
in
hemLib
