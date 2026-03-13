{
  config,
  pkgs,
  secrets,
  ...
}:

{
  home = {
    username = "swansono";
    homeDirectory = "/home/swansono";
    sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  hem.bat.enable = true;
  hem.fd.enable = true;
  hem.fish.enable = true;
  hem.fzf.enable = true;
  hem.jq.enable = true;
  hem.neovim.enable = true;
  hem.ripgrep.enable = true;
  hem.starship.enable = true;
  hem.tealdeer.enable = true;
  hem.tokei.enable = true;
  hem.git.enable = true;
  hem.git.commitSigning.ssh.pubKey = "~/.ssh/github.pub";
  programs.git.settings.user.email = secrets.work.email;
  programs.git.settings.user.name = secrets.work.name;
}
