{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hem.fzf;
in
{
  options.hem.fzf = {
    enable = lib.mkEnableOption "fzf";
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
