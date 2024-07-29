{ config, pkgs, ... }:

{
  home = {
    username = "swansono";
    homeDirectory = "/Users/swansono";

    packages = with pkgs; [
      pinentry-tty
    ];

    file."${config.home.homeDirectory}/.gnupg/gpg-agent.conf".text = ''
      pinentry-program ${config.home.homeDirectory}/.nix-profile/bin/pinentry-tty
      default-cache-ttl 43200
      max-cache-ttl 86400
    '';
  };

  programs = {
    fish = {
      shellInit = builtins.readFile ./patches/config.fish;
    };

    gpg = {
      enable = true;
    };

  };
}
