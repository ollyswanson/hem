{ lib, config, pkgs, ... }:

let 
  cfg = config.hem.neovim;
in
{
  options.hem.neovim = {
    enable = lib.mkEnableOption "neovim";

    symlink = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/hem/dotfiles/neovim";
    };
  };

  config = {
    home.packages = with pkgs; [
      neovim
    ];

    xdg.configFile.nvim = {
      # Caution, this is an absolute path :(
      # The absolute path is required because relative paths are relative to the nix store AND we
      # don't want to have to invoke `home-manager switch` every time we update the neovim config.
      source = config.lib.file.mkOutOfStoreSymlink cfg.symlink;
    };
  };
}
