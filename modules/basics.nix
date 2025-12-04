{ inputs, pkgs, ... }:

let
  zen_repo = inputs.zen-browser.packages."x86_64-linux";
in
{
  nix = {
    package = pkgs.nix;
    settings = {
      # enable flakes
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      # extra-trusted-substituters = [
      #   "https://cache.flox.dev"
      # ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # extra-trusted-public-keys = [
      #   "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      # ];
    };
  };

  environment.variables = {
    EDITOR = "hx";
  };

  # pkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.helix
    pkgs.yazi
    pkgs.ghostty
    pkgs.htop
    pkgs.mpv
    pkgs.pavucontrol
    pkgs.git
    pkgs.firefox
    pkgs.chromium
    pkgs.thunderbird
    zen_repo.twilight
    pkgs.udiskie
    pkgs.unzip
    # pkgs.zoxide
    pkgs.altus
    pkgs.tree
    pkgs.video-trimmer

    # language servers
    pkgs.jdt-language-server
    pkgs.texlab
    pkgs.neofetch
    pkgs.nil
    pkgs.ruff
    pkgs.ty
    pkgs.python312Packages.jedi-language-server
    pkgs.python312Packages.python-lsp-server
  ];

  users.defaultUserShell = pkgs.fish;
  
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

    packages = with pkgs; [
      noto-fonts-cjk-sans
      font-awesome
      nerd-fonts.jetbrains-mono
      material-design-icons
    ]
    # ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts))
    ;
  };  

  # mouse tweaks
  # expose webusb for scyrox mouse
  services.udev.extraRules =''
      KERNEL=="hidraw*", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f5f6", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f5f7", MODE="0666", TAG+="uaccess"
    '';

  # disable libinput's debounce algorithm for all mice
  environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
      [Never Debounce]
      MatchUdevType=mouse
      ModelBouncingKeys=1
  '';  
}
