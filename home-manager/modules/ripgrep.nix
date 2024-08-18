{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hem.ripgrep;
in
{
  options.hem.ripgrep = {
    enable = lib.mkEnableOption "ripgrep";
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--max-columns-preview"
        "--max-columns=150"
      ];
    };
  };
}
