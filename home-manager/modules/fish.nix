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

    shellAbbrs = {
      e = "nvim";
      gs = "git status";
    };

    functions = {
      # Move to the nearest parent directory that is a git repository root.
      d = ''
        while test $PWD != "/"
          if test -d .git
            break
          end
          cd ..
        end
      '';
      cdf = ''
        cd $HOME
        cd (fd --type directory --follow | fzf)
      '';
      jqf = {
        argumentNames = [ "file" ];
        # In nix '' strings: ''' = literal '', ''$ = literal $
        body = ''echo ''' | fzf --preview "jq {q} < "''$file'';
      };
      reload_shell = "source ~/.config/fish/config.fish";
    };

    # LESS_TERMCAP variables use escape sequences that don't fit
    # sessionVariables cleanly, so we keep them as shellInit.
    shellInit = ''
      setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
      setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
      setenv LESS_TERMCAP_me \e'[0m'           # end mode
      setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
      setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
      setenv LESS_TERMCAP_ue \e'[0m'           # end underline
      setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline
    '';
  };
}
