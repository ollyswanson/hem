{
  config,
  pkgs,
  secrets,
  ...
}:
let
  hem = config.hem;
in

{
  home = {
    username = "swansono";
    homeDirectory = "/home/swansono";

    packages = with pkgs; [ fd ];

    sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

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

  hem.fzf.enable = true;
  hem.neovim.enable = true;
  hem.ripgrep.enable = true;
  hem.starship.enable = true;
  hem.git.enable = true;
  hem.git.commitSigning.ssh.pubKey = "~/.ssh/github.pub";
  programs.git.userEmail = secrets.work.email;
  programs.git.userName = secrets.work.name;
}
