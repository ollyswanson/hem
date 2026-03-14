{ pkgs, ... }:
{
  home.packages = [ pkgs.jj-starship ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    presets = [ "bracketed-segments" ];
    settings = {
      add_newline = false;
      command_timeout = 1000;
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      aws.disabled = true;
      gcloud.disabled = true;
      # Built-in git modules are replaced by jj-starship, which handles
      # both jj and pure-git repos with a single optimized binary.
      # https://github.com/dmmulroy/jj-starship
      git_branch.disabled = true;
      git_commit.disabled = true;
      git_metrics.disabled = true;
      git_state.disabled = true;
      git_status.disabled = true;

      custom.jj = {
        when = "jj-starship detect";
        shell = [ "jj-starship" "--jj-symbol" " 󱗆 " ];
        command = "prompt";
        format = " $output";
      };

      direnv = {
        format = ''\[[$symbol$loaded/$allowed]($style)\]'';
      };
      nix_shell = {
        symbol = "❄️nix";
        format = ''\[[$symbol]($style)\]'';
       };
    };
  };
}
