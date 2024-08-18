{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hem.fd;
in
{
  options.hem.fd = {
    enable = lib.mkEnableOption "fd";
  };

  config = lib.mkIf cfg.enable {
    programs.fd = {
      enable = true;
    };
  };
}
