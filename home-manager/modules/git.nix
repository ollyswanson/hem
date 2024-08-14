{ lib, config, pkgs, ... }:

let
  cfg = config.hem.git;
in
{
  options.hem.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      delta.enable = true;
    };
  };
}
