{
  config,
  pkgs,
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

  # ============================================================================
  # Secrets
  # ============================================================================

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets = {
      work_email = { };
      work_name = { };
    };
  };

  sops.templates."git-identity".content = ''
    [user]
        email = ${config.sops.placeholder.work_email}
        name = ${config.sops.placeholder.work_name}
  '';

  programs.git.includes = [
    { path = config.sops.templates."git-identity".path; }
  ];

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
}
