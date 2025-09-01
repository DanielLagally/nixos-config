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
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  environment.variables = {
    EDITOR = "hx";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    unstable.helix
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
    unstable.zoxide
    unstable.altus

    # language servers
    unstable.jdt-language-server
    unstable.texlab
    unstable.neofetch
    unstable.nil
    unstable.ruff
  ];

  programs.nix-ld.enable = true;
  programs.direnv.enable = true;

  fonts = {
    enableDefaultPackages = true;

    packages = with unstable; [
      noto-fonts-cjk-sans
      font-awesome
    ] ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues unstable.nerd-fonts));
  };  
}
