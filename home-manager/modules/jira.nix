{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hem.jira;
in
{
  options.hem.jira = {
    enable = lib.mkEnableOption "jira";
  };

  config = {
    home.packages = with pkgs; [ jira-cli-go ];
  };
}
