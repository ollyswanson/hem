{
  config,
  pkgs,
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

  # ============================================================================
  # Secrets
  # ============================================================================

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets = {
      work_email = { };
      work_name = { };
      noreply_email = { };
      noreply_name = { };
    };
  };

  # Git identity via a template that's rendered at activation time, then
  # included by git's config.
  sops.templates."git-identity".content = ''
    [user]
        email = ${config.sops.placeholder.work_email}
        name = ${config.sops.placeholder.work_name}
  '';

  programs.git.includes = [
    { path = config.sops.templates."git-identity".path; }
  ];

  # Jujutsu identity via environment variables, which override config file
  # settings. Read from sops secret files at shell startup.
  programs.fish.shellInit = ''
    setenv TILT_HOST '0.0.0.0'
    setenv GPG_TTY (tty)
    setenv JJ_USER (cat ${config.sops.secrets.noreply_name.path})
    setenv JJ_EMAIL (cat ${config.sops.secrets.noreply_email.path})
  '';

  programs.fish.functions.proj = ''
    cd $HOME/passfort/MiniFort/projects
    cd (fd --type directory --follow | fzf)
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
  hem.jujutsu.enable = true;
}
