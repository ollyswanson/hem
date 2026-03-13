{ ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "nightfox";
        src = ../../dotfiles/fish/conf.d/nightfox.fish;
      }
    ];
    shellInit = builtins.readFile ../../dotfiles/fish/config.fish;
  };
}
