## Known gotchas

### Hyprland Lua overlays vs `_upstream` symlinks

Uncustomized files under `dotfiles/hypr/hyprland/` are symlinks to `dotfiles/hypr/_upstream` (`caelestia-dots/hypr`). Writing through the symlink overwrites upstream. If that overlay then `require`s `_upstream.hyprland.<samefile>`, Hyprland stack-overflows on reload.

To overlay: `rm` the symlink, then create a real file that `require`s `_upstream.hyprland.<module>` (same pattern as `general.lua` / `misc.lua`).
