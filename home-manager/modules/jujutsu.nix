{
  lib,
  config,
  ...
}:

let
  cfg = config.hem.jujutsu;
in
{
  options.hem.jujutsu = {
    signingKey = lib.mkOption {
      description = "Path to the SSH public key used for commit signing.";
      type = lib.types.str;
    };
  };

  config.programs.jujutsu = {
    enable = true;
    settings.signing = {
      backend = "ssh";
      key = cfg.signingKey;
    };
  };
}
