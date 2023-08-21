{ config, pkgs, ... }:

{
  home.username = "swansono";
  home.homeDirectory = "/Users/swansono";

  programs.fish = {
    shellInit = builtins.readFile ./patches/config.fish;
  };
}
