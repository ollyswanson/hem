{ config, pkgs, secrets, ... }:
let hem = config.hem; in

{
  home = {
    username = "swansono";
    homeDirectory = "/home/swansono";

    packages = with pkgs; [
      fd
      git-crypt
    ];

    sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "24.05";
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
  hem.neovim.enable = true;
  hem.git.enable = true;
  programs.git.userEmail = secrets.work.email;
  programs.git.userName = secrets.work.name;
}
