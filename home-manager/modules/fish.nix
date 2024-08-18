{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hem.fish;
in
{
  options.hem.fish = {
    enable = lib.mkEnableOption "fish";
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      plugins = [
        {
          name = "nightfox";
          src = ../../dotfiles/fish/conf.d/nightfox.fish;
        }
      ];
      shellInit = builtins.readFile ../../dotfiles/fish/config.fish;
    };
  };
}
