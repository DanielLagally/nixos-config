{ inputs, system, unstable,  ... }:

let
  rose-pine = inputs.rose-pine-hyprcursor.packages."x86_64-linux";
  caelestia-pkg = inputs.caelestia-cli.packages.${system}.with-shell;
in
{
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
    # portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

    xwayland.enable = true;
  };
  programs.xwayland.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # portals
  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    extraPortals = [ unstable.xdg-desktop-portal-gtk ]; # gtk or nvidia?
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "foot.desktop"
      ];
    };
  };

  # fix waybar not displaying hyprland workspaces
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  programs.bash.shellAliases = {
    hy = "hyprland";
  };
 
  environment.systemPackages =  [
    rose-pine.default
    unstable.waybar
    unstable.rofi
    unstable.dunst
    unstable.hyprpaper
    unstable.hyprpicker
    unstable.hyprpolkitagent
    unstable.hyprcursor
    unstable.grimblast
    unstable.rose-pine-cursor
    unstable.nwg-look
    unstable.playerctl
    unstable.wl-clipboard
    unstable.wallust
    unstable.brightnessctl
    unstable.hyprsunset
    unstable.hyprlock
    unstable.hypridle

    # caelestia stuff
    caelestia-pkg
    unstable.starship
    unstable.fastfetch
    unstable.btop
    unstable.eza
    unstable.app2unit
    unstable.jq
    unstable.papirus-icon-theme
    unstable.cliphist
    unstable.inotify-tools
    unstable.libnotify
    unstable.trash-cli
    unstable.quickshell
  ];
  programs.gpu-screen-recorder.enable = true;
}
