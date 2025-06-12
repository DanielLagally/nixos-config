{ inputs, stable, unstable, ... }:

let
  zen_repo = inputs.zen-browser.packages."x86_64-linux";
in
{
  # enable flakes
  nix = {
    package = unstable.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };

  environment.variables = {
    EDITOR = "hx";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    unstable.helix
    unstable.jdt-language-server
    unstable.texlab
    unstable.neofetch
    unstable.nil
    unstable.ruff
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

  programs.nix-ld.enable = true;
  programs.direnv.enable = true;
}
