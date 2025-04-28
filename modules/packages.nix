{ inputs, stable, unstable, ... }:

let
  zen_repo = inputs.zen-browser.packages."x86_64-linux";
in
{
  # global setting (kinda redundant)
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    unstable.helix
    unstable.firefox
    unstable.neofetch
    unstable.nil
    (unstable.discord.override {
    #  withOpenASAR = true;
    #  withVencord = true;
    })
    unstable.anki
    zen_repo.twilight
    unstable.prismlauncher
    unstable.yazi
    unstable.obsidian
    unstable.ghostty
    unstable.shipwright
    unstable.htop
    unstable.bitwig-studio
    unstable.mpv
    unstable.thunderbird
    unstable.pavucontrol
    unstable.yabridge
    unstable.yabridgectl
    unstable.wineWowPackages.staging
    unstable.winetricks
    unstable.git
    unstable.chromium
    unstable.wallust
  ];
}
