## Known gotchas

### Hyprland Lua overlays vs `_upstream` symlinks

Uncustomized files under `dotfiles/hypr/hyprland/` are symlinks to `dotfiles/hypr/_upstream` (`caelestia-dots/hypr`). Writing through the symlink overwrites upstream. If that overlay then `require`s `_upstream.hyprland.<samefile>`, Hyprland stack-overflows on reload.

To overlay: `rm` the symlink, then create a real file that `require`s `_upstream.hyprland.<module>` (same pattern as `general.lua` / `misc.lua`).

### Nix flake eval only sees git-tracked files

Nix copies only tracked/staged files when evaluating this repo as a flake. A gitignored file referenced from a module silently disappears from evaluation (`builtins.pathExists` → false, no error). Anything read at eval time must be tracked (encrypted, e.g. sops) or live outside the repo (e.g. `~/.config/...`, like karakeep's environmentFile).

### sops-nix: secrets are activation-time, never eval-time

Values from `secrets/*.yaml` may only surface via `config.sops.templates.*` placeholders (`config.sops.placeholder."..."`), rendered at activation into `/run/secrets/rendered/`. Interpolating a secret into an eval-time option puts the plaintext into the world-readable nix store. Caddy consumes the rendered file through `services.caddy.configFile` (the module symlinks `/etc/caddy/caddy_config` → `/run/secrets/rendered/Caddyfile`).

### Multi-flake lock layout (root → machines/<host> → ../../inputs)

Two lock files only: root `flake.lock` and `inputs/flake.lock`. **Never create `machines/<host>/flake.lock` files** — this repo deliberately has none; the root lock records the full resolved subtree for each per-machine path input. After adding an input to `inputs/flake.nix`: run `nix flake lock ./inputs`, then `nix flake update <host>` to refresh the subtree in the root lock. Skipping the refresh gives a misleading `error: attribute 'X' missing` at eval even though `inputs/flake.lock` is correct. Do NOT eval `machines/<host>#…` directly — it forks a stray per-machine lock file (delete it if that happens).

### Root-owned `.git/objects/*` subdirs

Some `.git/objects/` fan-out dirs are root-owned (from past `sudo` git writes inside this repo, e.g. `sudo nixos-rebuild` run from the repo). Git writes of any object with that hash prefix fail with `insufficient permission for adding an object to repository database`; nix flake lock updates then die with `program "git" failed with exit code 128`. One-time fix: `sudo chown -R daniel:users .git/objects`. Workaround until then: `git add` new files *before* running nix evals (nix's intent-to-add for untracked files needs to write the empty blob, `e69de29b…`, which lives in the broken dir).
