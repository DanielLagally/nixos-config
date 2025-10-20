{ inputs, stable, unstable, ... }:

let
  zen_repo = inputs.zen-browser.packages."x86_64-linux";
in
{
  nix = {
    package = unstable.nix;
    settings = {
      # enable flakes
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
    # unstable.zoxide
    unstable.altus
    unstable.tree
    unstable.video-trimmer

    # language servers
    unstable.jdt-language-server
    unstable.texlab
    unstable.neofetch
    unstable.nil
    unstable.ruff
    unstable.ty
    unstable.python312Packages.jedi-language-server
    unstable.python312Packages.python-lsp-server
  ];

  users.defaultUserShell = unstable.fish;
  
  programs = {
    nix-ld.enable = true;
    direnv = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    fish.enable = true;
    bash.enable = false;
    foot = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };

  qt.style = "adwaita-dark";

  fonts = {
    enableDefaultPackages = true;

    packages = with unstable; [
      noto-fonts-cjk-sans
      font-awesome
    ] ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues unstable.nerd-fonts));
  };  

  # mouse tweaks
  # expose webusb for scyrox mouse
  services.udev.extraRules =''
      KERNEL=="hidraw*", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f5f6", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f5f7", MODE="0666", TAG+="uaccess"
    '';

  # disable libinput's debounce algorithm for all mice
  environment.etc."libinput/local-overrides.quirks".text = unstable.lib.mkForce ''
      [Never Debounce]
      MatchUdevType=mouse
      ModelBouncingKeys=1
  '';  
}
