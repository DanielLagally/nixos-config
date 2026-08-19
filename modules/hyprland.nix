{ inputs, system, pkgs, ... }:

let
  rose-pine = inputs.rose-pine-hyprcursor.packages."x86_64-linux";
  caelestia-pkg = inputs.caelestia-cli.packages.${system}.with-shell;
in
{
  # enables upstream hyprland flake
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  # enable opengl
  hardware.graphics = {
    enable = true;
    package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system}.mesa;
    package32 = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system}.pkgsi686Linux.mesa;
  };

  # enable hyprland
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };
  programs.xwayland.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # theme stuff
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          gtk-theme = "Adwaita";
          icon-theme = "Flat-Remix-Red-Dark";
          font-name = "Noto Sans Medium 11";
          document-font-name = "Noto Sans Medium 11";
          monospace-font-name = "Noto Sans Mono Medium 11";
        };
      }
    ];
  };
  # portals
  # (extraPortals already includes xdg-desktop-portal-gtk by default, via
  # nixpkgs' own programs.hyprland module -> wayland-session.nix)
  xdg.portal = {
    enable = true;
    config = {
      # gtk's own .portal file restricts itself to `UseIn=gnome`, so it
      # won't get picked under XDG_CURRENT_DESKTOP=Hyprland unless named
      # explicitly here — this is what apps' dark/light mode queries
      # (org.freedesktop.impl.portal.Settings) depend on, since the
      # hyprland portal only implements Screenshot/ScreenCast/etc, not
      # Settings.
      common.default = [ "hyprland" "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };

  # No display manager — Hyprland is started manually from a TTY (the `hy`
  # alias below), which by itself never activates graphical-session.target,
  # so anything gated on it (like xdg-desktop-portal.service) never starts.
  # Using the plain hyprland-session.target recipe (wiki: Useful-Utilities/
  # Systemd-start) instead of UWSM — keeps the `start-hyprland` launch
  # exactly as before; Hyprland itself starts/stops this via hl.on(...)
  # hooks in hypr/hyprland.lua.
  systemd.user.targets.hyprland-session = {
    description = "Hyprland session";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    unitConfig.PropagatesStopTo = "graphical-session.target";
  };

  # xdg.terminal-exec = {
  #   enable = true;
  #   settings = {
  #     default = [
  #       "foot.desktop"
  #     ];
  #   };
  # };

  programs.bash.shellAliases = {
    hy = "start-hyprland";
  };
  programs.fish.shellAliases = {
    hy = "start-hyprland";
  };

  environment.systemPackages =  [
    rose-pine.default
    pkgs.waybar
    pkgs.rofi
    pkgs.dunst
    pkgs.hyprpaper
    pkgs.hyprpicker
    pkgs.hyprpolkitagent
    pkgs.hyprcursor
    pkgs.grimblast
    pkgs.rose-pine-cursor
    pkgs.nwg-look
    pkgs.playerctl
    pkgs.wl-clipboard
    pkgs.wallust
    pkgs.brightnessctl
    pkgs.hyprsunset
    pkgs.hyprlock
    pkgs.hypridle

    # caelestia stuff
    caelestia-pkg
    pkgs.starship
    pkgs.fastfetch
    pkgs.btop
    pkgs.eza
    pkgs.app2unit
    pkgs.jq
    pkgs.papirus-icon-theme
    pkgs.cliphist
    pkgs.inotify-tools
    pkgs.libnotify
    pkgs.trash-cli
    pkgs.quickshell
    pkgs.bluez
    pkgs.ddcutil
  ];
  programs.gpu-screen-recorder.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Enable backlight control
  hardware.i2c.enable = true;
}
