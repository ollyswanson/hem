{ ... }:
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = ''fd --type file --follow --hidden --exclude ".git"'';
    changeDirWidgetCommand = ''fd --type directory --follow --hidden --exclude ".git"'';
    defaultOptions = [ "--height 40%" ];
  };
}
