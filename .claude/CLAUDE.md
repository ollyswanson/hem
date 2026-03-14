# hem

Nix home-manager configuration managing two hosts: `work` (aarch64-darwin)
and `orbstack` (aarch64-linux).

## Adding packages

- One module per package: `home-manager/modules/<name>.nix`
- Prefer `programs.<name>.enable = true` when home-manager has a module
  for the program. Fall back to `home.packages` with nixpkgs when it
  doesn't.
- Modules are pure config — `extendModules` in `lib/default.nix`
  automatically wraps each module with `hem.<name>.enable` and `mkIf`.
  Do not add enable options or `mkIf` guards manually.
- Enable packages in `hosts/<host>/home.nix` with
  `hem.<name>.enable = true`.
- After creating a new module file, run `jj status` before building —
  this snapshots the file into the working copy commit, making it
  visible to nix (which only sees tracked files).

## Building

```sh
home-manager build --flake .#work
home-manager build --flake .#orbstack
```
