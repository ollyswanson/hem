{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hem.nixd;
in
{
  options.hem.nixd = {
    enable = lib.mkEnableOption "nixd";
  };

  config = {
    home.packages = with pkgs; [ nixd ];
  };
}
