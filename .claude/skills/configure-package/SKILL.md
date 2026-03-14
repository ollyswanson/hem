---
name: configure-package
description: Explore a package's configuration in depth — find integration opportunities with other installed tools, surface uncommon but useful options, and check if the tool can do something specific
argument-hint: <package-name> [goal]
---

Deep-dive into the configuration of `$ARGUMENTS` (the first word is the
package name; anything after it is an optional goal the user wants to
achieve with the tool).

## Context gathering

1. **Read the existing module** at
   `home-manager/modules/<package>.nix` to understand what's already
   configured.

2. **List all installed modules** by scanning
   `home-manager/modules/*.nix` — these are the tools available for
   cross-tool integrations.

3. **Fetch the home-manager module source** from
   `https://raw.githubusercontent.com/nix-community/home-manager/master/modules/programs/<package>.nix`.
   This is the definitive list of declarative options available.

4. **Fetch upstream documentation.** Look for the tool's official
   config reference. For well-known tools, try common documentation
   URLs (man pages, GitHub READMEs, official sites). Use `WebFetch` to
   pull relevant pages. Focus on configuration options, not
   installation or tutorials.

## Analysis

Present findings to the user in three sections. Be concise — use
tables or short bullet lists, not walls of text. For each
recommendation, show the nix config snippet that would implement it.

### 1. Integration opportunities

Look at the other installed modules and identify cross-tool
integrations. Examples of what to look for:

- Shell integrations (`enableFishIntegration`, `enableBashIntegration`)
  that aren't turned on yet
- Tools that can use each other (e.g., bat as a pager for git, fzf
  preview using bat/eza/fd, direnv + nix shells)
- Shared config that should be consistent (e.g., color themes, editor
  settings)
- Programs that register as handlers for other programs (e.g.,
  difftastic as a git diff tool)

For each integration, explain *what it does* and *why it's useful*
given the user's specific toolset.

### 2. Uncommon but useful options

Surface options that most users don't configure but that are genuinely
valuable. Skip the obvious ones (enable, package). Focus on:

- Options with non-trivial defaults that might not match the user's
  workflow
- Feature flags that unlock significant functionality
- Settings that reduce friction or improve ergonomics
- Options that are easy to miss in the docs

For each, briefly explain what it does and when you'd want it.

### 3. Goal-directed exploration (if a goal was provided)

If the user included a goal after the package name, investigate
whether and how the tool can accomplish it. Check:

- Built-in configuration options
- Integration with other installed tools
- Workarounds via extraConfig or settings attrsets
- Whether a different tool in the ecosystem would be better suited

Be honest if the tool can't do what's asked — suggest alternatives.

## Applying changes

After presenting findings, ask the user which changes (if any) they
want to apply. Then:

1. Edit `home-manager/modules/<package>.nix` with the chosen config.
2. Build to verify: `home-manager build --flake .#work` (and/or
   `#orbstack` if the module is enabled there).
