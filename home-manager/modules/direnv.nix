{ lib
, config
, pkgs
, ...
}:

let
  cfg = config.hem.direnv;
in
{
  options.hem.direnv = {
    enable = lib.mkEnableOption "direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
