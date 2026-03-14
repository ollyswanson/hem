{ ... }:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--hyperlink"
      "--no-quotes"
      "--binary"
      "--time-style=relative"
    ];
  };
}
