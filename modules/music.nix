{ inputs, stable, unstable, ... }:

let
in
{
  environment.systemPackages = [
    unstable.bitwig-studio
    unstable.yabridge
    unstable.yabridgectl
    unstable.wineWowPackages.staging
    unstable.winetricks
  ];
}
