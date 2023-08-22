{ config, pkgs, ... }:

{
  home = {
    stateVersion = "23.05";

    packages = with pkgs; [
      neovim
      fd
    ];

    sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
    };
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
      {
        name = "fzf_key_bindings";
        src = ../dotfiles/fish/conf.d/fzf_key_bindings;
      }
    ];
    shellInit = builtins.readFile ../dotfiles/fish/config.fish;
  };

  programs.starship = import ../programs/starship.nix;
}
