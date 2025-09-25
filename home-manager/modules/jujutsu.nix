{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hem.jujutsu;
in
{
  options.hem.jujutsu = {
    enable = lib.mkEnableOption "jujutsu";
  };

  config = lib.mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
    };
  };
}
