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

  programs.fish.functions.proj = ''
    cd $HOME/passfort/MiniFort/projects
    cd (fd --type directory --follow | fzf)
  '';
  programs.fish.shellInit = ''
    setenv TILT_HOST '0.0.0.0'
    setenv GPG_TTY (tty)
  '';

  hem.bat.enable = true;
  hem.difftastic.enable = true;
  hem.direnv.enable = true;
  hem.eza.enable = true;
  hem.fd.enable = true;
  hem.fish.enable = true;
  hem.fzf.enable = true;
  hem.jira.enable = true;
  hem.jq.enable = true;
  hem.just.enable = true;
  hem.navi.enable = true;
  hem.neovim.enable = true;
  hem.nixd.enable = true;
  hem.ripgrep.enable = true;
  hem.starship.enable = true;
  hem.tealdeer.enable = true;
  hem.tokei.enable = true;
  hem.git.enable = true;
  hem.git.commitSigning.ssh.pubKey = "~/.ssh/github.pub";
  hem.zed.enable = true;
  programs.git.settings.user.email = secrets.work.email;
  programs.git.settings.user.name = secrets.work.name;
  hem.jujutsu.enable = true;
  programs.jujutsu.settings = {
    user = {
      email = secrets.noreply.email;
      name = secrets.noreply.name;
    };
  };
}
