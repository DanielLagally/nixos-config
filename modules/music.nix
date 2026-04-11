{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.bitwig-studio
    pkgs.yabridge
    pkgs.yabridgectl
    pkgs.wineWow64Packages.staging
    pkgs.winetricks
    pkgs.easyeffects
  ];
}
