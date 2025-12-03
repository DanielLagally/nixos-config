{ inputs, system, unstable, home-manager, lib, ... }:

let
  rose-pine = inputs.rose-pine-hyprcursor.packages."x86_64-linux";
  caelestia-pkg = inputs.caelestia-cli.packages.${system}.with-shell;
  hypr-plugin-dir = unstable.symlinkJoin {
    name = "hyprland-plugins";
    paths = [
      # inputs.hyprtasking.packages.${system}.hyprtasking # appears to be broken, need to update hyprland which breaks caelestia-shell :)
      inputs.hyprsplit.packages.${system}.hyprsplit
    ];
  };
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
    # portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    # option exposed by upstream flake, does not work though
    # plugins = [
    #   inputs.split-monitor-workspaces.packages.x86_64-linux.split-monitor-workspaces
    #   unstable.hyprlandPlugins.hyprexpo
    #   unstable.hyprlandPlugins.hyprspace
    #   inputs.hyprland-plugins.packages.x86_64-linux.hyprexpo
    # ];

    xwayland.enable = true;
  };
  programs.xwayland.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    HYPR_PLUGIN_DIR = hypr-plugin-dir;
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
  # # portals
  # xdg.portal = {
  #   enable = true;
  #   # wlr.enable = true;
  #   extraPortals = [ unstable.xdg-desktop-portal-gtk ]; # gtk or nvidia?
  # };

  # xdg.terminal-exec = {
  #   enable = true;
  #   settings = {
  #     default = [
  #       "foot.desktop"
  #     ];
  #   };
  # };

  programs.bash.shellAliases = {
    hy = "hyprland";
  };
  programs.fish.shellAliases = {
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
