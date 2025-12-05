{ pkgs, ... } :

{
  nix = {
    enable = false;
    # package = unstable.nix;
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  determinate-nix.customSettings = {
    eval-cores = 0; 
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
    fish.enable = true;
    direnv.enable = true;
  };

  services = {
    aerospace = {
      enable = true;
      # settings = pkgs.lib.importTOML /Users/daniellagally/.config/aerospace/aerospace.toml;
    };
  };

  users = {
    knownUsers = [ "daniellagally" ];
    users.daniellagally = {
      uid = 501;
      shell = pkgs.fish;
      packages = [
        pkgs.hello
      ];
    };
  };

  environment = {
    shells = [ pkgs.fish ];
    darwinConfig = "/Users/daniellagally/nixos-config";
    variables = { EDITOR = "hx"; };
    systemPackages = [
      pkgs.kitty
      pkgs.fish
      pkgs.starship
      pkgs.fastfetch
      pkgs.zoxide
      pkgs.eza
      # pkgs.aerospace
      # inputs.zen-browser.packages."aarch64-darwin".twilight
    ];
  };

  system = {
    stateVersion = 6;
    primaryUser = "daniellagally";
  };
}
