{
  config,
  pkgs,
  secrets,
  ...
}:

{
  home = {
    username = "swansono";
    homeDirectory = "/Users/swansono";
    sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  programs.fish.shellInit = builtins.readFile ./patches/config.fish;

  hem.direnv.enable = true;
  hem.fd.enable = true;
  hem.fish.enable = true;
  hem.fzf.enable = true;
  hem.jira.enable = true;
  hem.neovim.enable = true;
  hem.nixd.enable = true;
  hem.ripgrep.enable = true;
  hem.starship.enable = true;
  hem.git.enable = true;
  hem.git.commitSigning.ssh.pubKey = "~/.ssh/github.pub";
  hem.zed.enable = true;
  programs.git.userEmail = secrets.work.email;
  programs.git.userName = secrets.work.name;
  hem.jujutsu.enable = true;
  programs.jujutsu.settings = {
    user = {
      email = secrets.noreply.email;
      name = secrets.noreply.name;
    };
  };
}
