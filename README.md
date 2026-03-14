# hem — Home Environment Manager

Olly's home-manager configuration, managing the `work` host
(aarch64-darwin) via a modular system under the `hem.*` option
namespace.

## Installation

`$HOST` is the host-specific configuration name, e.g. "work" or
"orbstack". This is the mechanism for per-machine configuration.

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

## Secrets management

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix)
using [age](https://github.com/FiloSottile/age) encryption. Encrypted
values live in `secrets/secrets.yaml` — keys are visible but values are
encrypted. Decryption happens at home-manager activation time, not at
nix evaluation time.

### Bootstrapping on a new machine

1. Place the age private key at `~/.config/sops/age/keys.txt`
   (obtain from your backup — never commit this file)
2. Run `home-manager switch --flake .#$HOST`

sops-nix will decrypt secrets during activation and place them under
`~/.config/sops-nix/secrets/`.

### Editing secrets

```
$ nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

This decrypts the file into your `$EDITOR`, and re-encrypts on save.
Never edit the encrypted file directly.

### Adding a new secret

1. Add the key to `secrets/secrets.yaml` via `sops` (as above)
2. Reference it in the relevant host config:
   ```nix
   # Decrypt to a file:
   sops.secrets.my_secret = { };
   # Then use the path: config.sops.secrets.my_secret.path

   # Or render into a config file template:
   sops.templates."my-config".content = ''
     token = ${config.sops.placeholder.my_secret}
   '';
   # Then use the path: config.sops.templates."my-config".path
   ```

### Key rotation

To add a new age key (e.g. for a new machine), add its public key to
`.sops.yaml` and re-encrypt:

```
$ nix shell nixpkgs#sops -c sops updatekeys secrets/secrets.yaml
```

## Architecture

### Directory structure

```
flake.nix                     # Entry point — defines homeConfigurations per host
lib/default.nix               # hemLib: mkHome, extendModules, mergeOnce
home-manager/
  default.nix                 # Uses extendModules to auto-wrap all modules
  modules/                    # One file per hem.* module (pure config)
hosts/
  work/home.nix               # macOS host config
dotfiles/                     # Out-of-store config files (neovim, zed, fish themes)
```

### The `hem.*` module namespace

Each file under `home-manager/modules/` becomes a module in the
`hem.<name>` namespace (name derived from filename). The
`extendModules` helper automatically adds a `hem.<name>.enable` option
and wraps the module's config in `mkIf cfg.<name>.enable`. Host configs
toggle modules by setting `hem.fd.enable = true`, etc.

### `extendModules` — automatic module wrapping

Module files are pure config — no `options.hem.*.enable` boilerplate,
no `mkIf` guards. The wrapper is applied at the import layer in
`home-manager/default.nix`. A simple module is just:

```nix
# modules/fd.nix
{ ... }: { programs.fd.enable = true; }
```

Modules that need extra options (e.g. git.nix with `commitSigning`,
neovim.nix with `symlink`) can still define an `options` block —
`extendModule` preserves it and only *adds* the enable option alongside.

### Adding a new module

1. Create `home-manager/modules/<name>.nix` with pure config
2. Enable in the relevant `hosts/*/home.nix` with `hem.<name>.enable = true`

### `mergeOnce` — recursive attrset merge with list dedup

Like `lib.recursiveUpdate` but when both sides have a list, it merges
them with `unique` instead of replacing. Used by `mkHome` to combine the
shared module base with host-specific config without losing either
side's `modules` or `extraSpecialArgs` lists.

### `mkOutOfStoreSymlink` — edit without rebuild

The neovim and zed modules use `config.lib.file.mkOutOfStoreSymlink` to
symlink config directories. This means changes to those dotfiles take
effect immediately without running `home-manager switch`.

### `mkHandlers` — tagged-union option dispatch

The git module uses `types.attrTag` for commit signing (SSH vs GPG) and
`mkHandlers` to dispatch on the tag. This pattern can be reused for any
option that needs variant/enum-style configuration.

### Adding a new host

1. Create `hosts/<name>/home.nix` with `home.username`, `homeDirectory`,
   `stateVersion`, and the desired `hem.*` enables
2. Add a `homeConfigurations.<name>` entry in `flake.nix` using
   `lib.mkHome "<system>" { modules = [ ./hosts/<name>/home.nix ]; }`

