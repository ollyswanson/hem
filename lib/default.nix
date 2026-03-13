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

  # ===========================================================================
  # Module extension helpers
  # ===========================================================================
  #
  # Automatically wraps module files with `hem.<name>.enable` options and
  # `mkIf` guards, so module files can be pure config without boilerplate.
  #
  # Usage in `home-manager/default.nix`:
  #
  #   ```
  #   { lib, config, ... }:
  #   let
  #     cfg = config.hem;
  #     modules = hemLib.extendModules
  #       (name: {
  #         extraOptions.hem.${name}.enable =
  #           lib.mkEnableOption "enable ${name}";
  #         configExtension = config: lib.mkIf cfg.${name}.enable config;
  #       })
  #       (hemLib.filesIn ./modules);
  #   in
  #   { imports = modules; }
  #   ```
  #
  # Module files then become pure config (no options, no mkIf):
  #
  #   ```
  #   # modules/fd.nix
  #   { ... }: { programs.fd.enable = true; }
  #   ```
  #
  # Modules that need extra options (e.g. git.nix with `commitSigning`)
  # can still define them — `extendModule` preserves `options` from the
  # module and only *adds* the enable option alongside them.

  filesIn =
    dir:
    map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir));

  fileNameOf =
    path:
    builtins.head (builtins.split "\\." (baseNameOf path));

  # Evaluates a module file and extends its options / config.
  #
  # - `extraOptions`: merged into the module's options (used to inject
  #   `hem.<name>.enable`)
  # - `configExtension`: wraps the module's config (used to inject
  #   `mkIf cfg.<name>.enable`)
  #
  # The module file can return either:
  # - `{ options = { ... }; config = { ... }; }` (explicit form)
  # - `{ programs.fd.enable = true; ... }` (shorthand — everything except
  #   `imports` and `options` is treated as config)
  extendModule =
    { path, ... }@args:
    { pkgs, ... }@margs:
    let
      eval =
        if (builtins.isString path) || (builtins.isPath path) then import path margs else path margs;
      evalNoImports = builtins.removeAttrs eval [
        "imports"
        "options"
      ];

      extra =
        if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args) then
          [
            (
              { ... }:
              {
                options = args.extraOptions or { };
                config = args.extraConfig or { };
              }
            )
          ]
        else
          [ ];
    in
    {
      imports = (eval.imports or [ ]) ++ extra;

      options =
        if builtins.hasAttr "optionsExtension" args then
          (args.optionsExtension (eval.options or { }))
        else
          (eval.options or { });

      config =
        if builtins.hasAttr "configExtension" args then
          (args.configExtension (eval.config or evalNoImports))
        else
          (eval.config or evalNoImports);
    };

  # Applies an extension to all module files. The extension function
  # receives the module name (derived from filename) and returns the
  # args for `extendModule`.
  extendModules =
    extension: modules:
    map (
      f:
      let
        name = fileNameOf f;
      in
      (extendModule ((extension name) // { path = f; }))
    ) modules;

  hemLib = {
    inherit
      eachSystem
      pkgsFor
      mkHome
      mergeOnce
      filesIn
      fileNameOf
      extendModule
      extendModules
      ;
  };
in
hemLib
