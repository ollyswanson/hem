{ ... }:
{
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--max-columns-preview"
      "--max-columns=150"
    ];
  };
}
