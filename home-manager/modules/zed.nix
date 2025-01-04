{ lib, config, ... }:

let
  cfg = config.hem.zed;
in
{
  # For now we're just going to manage Zed's config files with nix.
  options.hem.zed = {
    enable = lib.mkEnableOption "zed";

    symlink = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/hem/dotfiles/zed";
    };
  };

  config = {
    xdg.configFile = {
      "zed/keymap.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${cfg.symlink}/keymap.json";
      };

      "zed/settings.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${cfg.symlink}/settings.json";
      };
    };
  };
}
