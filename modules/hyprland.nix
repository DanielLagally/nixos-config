{ inputs, system, unstable,  ... }:

let
  rose-pine = inputs.rose-pine-hyprcursor.packages."x86_64-linux";
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
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

    xwayland.enable = true;
  };
  programs.xwayland.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # portals
  xdg.portal = {
    enable = true;
    extraPortals = [ unstable.xdg-desktop-portal-gtk ]; # gtk or nvidia?
  };

  # fix waybar not displaying hyprland workspaces
  nixpkgs.overlays = [
    (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
    })
  ];
  
  environment.systemPackages =  [
    rose-pine.default
    unstable.waybar
    unstable.rofi-wayland
    unstable.dunst
    unstable.hyprpaper
    unstable.hyprpicker
    unstable.hyprpolkitagent
    unstable.hyprcursor
    unstable.hyprshot
    unstable.rose-pine-cursor
    unstable.nwg-look
    unstable.playerctl
    unstable.wl-clipboard
    unstable.wallust
  ];
}
