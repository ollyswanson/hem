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
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    ;
in
{
  options.hem.git = {
    enable = mkEnableOption "git";
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

  config =
    let
      # This is essentially a way of producing match statements for the
      # commitSigning attrTag option. It seems like an unnecessary abstraction
      # here, but that's only because I haven't implemented the GPG option...
      # yet... Anyway, it'll be necessary because we need to return a
      # `config.programs` and a `config.hem.gpg.enable` (for the GPG bit) but
      # due to issues with infinite recursion[1] we can't `mkMerge` on the top
      # level config, but instead have to `mkMerge` on `config.programs`,
      # `config.hem.gpg` etc.
      #
      # [1]: https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
      mkHandlers =
        { ssh, gpg }@handlers:
        commitSigning:
        let
          tag = lib.head (lib.attrNames commitSigning);
        in
        handlers.${tag} commitSigning.${tag};
    in
    {
      programs = mkIf cfg.enable (mkMerge [
        {
          git = {
            enable = true;
            delta.enable = true;
          };
        }
        (
          let
            ssh =
              { pubKey }:
              {
                git.extraConfig = {
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
      ]);

      home.packages = mkIf cfg.enable (with pkgs; [ git-crypt ]);
    };
}
