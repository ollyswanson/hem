# Installation

---
$HOST -> Host specific configuration, e.g. "work". This is the mechanism for having some
"per-machine" configuration.

---

### Initial installation
```
$ nix build .#homeConfigurations.$HOST.activationPackage
$ ./result/activate
```

### Updating
```
$ nix flake update
$ home-manager switch --flake .#$HOST
```

# TODOs
- [ ] Git config
- [x] gpg-agent
- [x] git-crypt: Not a good idea, need to find an alternative.
- [ ] Bat configuration
- [ ] Review nerdtree plugin for Neovim (is there a better option?)
- [ ] Lots of shell aliases
- [ ] Fzf plugin for fish (the `git rev-parse` integration looks really useful)
- [ ] Git integration with neovim.
- [ ] [List of packages that need to be migrated](./TO_MIGRATE.md)
