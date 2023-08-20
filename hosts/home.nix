{ config, pkgs, ... }:

{
  home = {
    stateVersion = "23.05";

    packages = with pkgs; [
      neovim
    ];
  };

  xdg.configFile.nvim = {
    # Caution, this is an absolute path :(
    # The absolute path is required because relative paths are relative to the nix store AND we
    # don't want to have to invoke `home-manager switch` every time we update the neovim config.
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/hem/dotfiles/neovim";
  };

  programs.home-manager.enable = true;

}
