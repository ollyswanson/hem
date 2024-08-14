{ config, pkgs, ... }:
let hem = config.hem; in

{
  home = {
    username = "swansono";
    homeDirectory = "/home/swansono";

    packages = with pkgs; [
      neovim
      fd
      git-crypt
    ];

    sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "24.05";
  };

  xdg.configFile.nvim = {
    # Caution, this is an absolute path :(
    # The absolute path is required because relative paths are relative to the nix store AND we
    # don't want to have to invoke `home-manager switch` every time we update the neovim config.
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/hem/dotfiles/neovim";
  };

  programs.home-manager.enable = true;

  programs.ripgrep = {
    enable = true;
    arguments = [ "--max-columns-preview" "--max-columns=150" ];
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "nightfox";
        src = ../dotfiles/fish/conf.d/nightfox.fish;
      }
    ];
    shellInit = builtins.readFile ../dotfiles/fish/config.fish;
  };

  programs.starship = import ../programs/starship.nix;

  imports = [../home-manager];

  hem.fzf.enable = true;
}
