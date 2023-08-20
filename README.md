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
