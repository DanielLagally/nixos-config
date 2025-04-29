{ inputs, stable, unstable, ... }:

let
  zen_repo = inputs.zen-browser.packages."x86_64-linux";
in
{
  environment.systemPackages = [
    unstable.helix
    unstable.neofetch
    unstable.nil
    unstable.yazi
    unstable.ghostty
    unstable.htop
    unstable.mpv
    unstable.pavucontrol
    unstable.git
    unstable.firefox
    unstable.chromium
    unstable.thunderbird
    zen_repo.twilight
    unstable.udiskie
  ];
}
