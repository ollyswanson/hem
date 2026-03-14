---
name: add-package
description: Add a new package module to the hem home-manager config
disable-model-invocation: true
argument-hint: <package-name>
---

Add the package `$ARGUMENTS` to the hem home-manager configuration.

## Steps

1. **Check for a home-manager module.** Fetch the module source from
   `https://raw.githubusercontent.com/nix-community/home-manager/master/modules/programs/$ARGUMENTS.nix`.
   If it exists, we'll use the home-manager module. If it 404s, fall
   back to adding the package via `home.packages`.

2. **Walk through the available options with the user.** If a
   home-manager module exists, read the source fetched in step 1 and
   summarize the interesting options (settings, shell integrations,
   extra packages, etc.). Ask which options should be configured
   beyond the default enable. Keep the summary concise — group
   related options and highlight the most useful ones. Skip trivially
   obvious options like `enable` and `package`.

3. **Create the module file** at `home-manager/modules/$ARGUMENTS.nix`.

   If using a home-manager module:
   ```nix
   { ... }:
   {
     programs.$ARGUMENTS.enable = true;
     # any additional config the user chose
   }
   ```

   If no home-manager module exists, fall back to nixpkgs:
   ```nix
   { pkgs, ... }:
   {
     home.packages = with pkgs; [ $ARGUMENTS ];
   }
   ```

4. **Stage the file** with `git add home-manager/modules/$ARGUMENTS.nix`
   so nix can see it.

5. **Ask which hosts to enable it on** (`work`, `orbstack`, or both).
   Add `hem.$ARGUMENTS.enable = true;` to each chosen host file under
   `hosts/<host>/home.nix`.

6. **Build to verify**: `home-manager build --flake .#work` (and/or
   `#orbstack` depending on what was enabled).
