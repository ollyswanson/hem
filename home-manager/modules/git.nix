{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hem.git;
  inherit (lib)
    types
    mkOption
    mkMerge
    ;
in
{
  options.hem.git = {
    commitSigning = mkOption {
      description = ''
        Configuration for signing commits.
      '';
      type = types.attrTag {
        ssh = mkOption {
          description = ''
            Sign commits using ssh.
          '';
          type = types.submodule {
            options.pubKey = mkOption {
              description = "The path to the public key that is being used.";
              type = types.str;
            };
          };
        };
        gpg = mkOption {
          description = "Sign commits using gpg.";
          type = types.submodule { }; # Not implemented yet.
        };
      };
    };
  };

  config = {
    programs = mkMerge [
      {
        git.enable = true;
        delta.enable = true;
      }
      (
        let
          # Dispatches on an `attrTag` option value by matching the tag name to a
          # handler function. This is the pattern for adding tagged-union style
          # options elsewhere — define the tag set with `types.attrTag`, then use
          # `mkHandlers` to produce the corresponding config for each variant.
          #
          # It seems like an unnecessary abstraction here because only SSH is
          # implemented, but it'll be necessary once GPG is added: we need to
          # produce different config branches (`config.programs` for SSH,
          # `config.hem.gpg.enable` for GPG) and due to infinite recursion[1]
          # we can't `mkMerge` on the top-level config, only on sub-trees like
          # `config.programs`.
          #
          # [1]: https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
          mkHandlers =
            { ssh, gpg }@handlers:
            commitSigning:
            let
              tag = lib.head (lib.attrNames commitSigning);
            in
            handlers.${tag} commitSigning.${tag};

          ssh =
            { pubKey }:
            {
              git.settings = {
                gpg.format = "ssh";
                user.signingkey = pubKey;
                commit.gpgsign = "true";
              };
            };
          gpg = args: { }; # Unimplemented at the moment
          handlers = mkHandlers { inherit ssh gpg; };
        in
        handlers cfg.commitSigning
      )
    ];

    home.packages = with pkgs; [ git-crypt ];
  };
}
