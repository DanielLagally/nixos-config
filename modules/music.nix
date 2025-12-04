{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.bitwig-studio
    pkgs.yabridge
    pkgs.yabridgectl
    pkgs.wineWowPackages.staging
    pkgs.winetricks
    pkgs.easyeffects
  ];
}
