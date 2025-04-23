{
  description = "main system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";    
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up to date or simply don't specify the nixpkgs input  
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    musnix  = { url = "github:musnix/musnix"; };
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = builtins.currentSystem or "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ./modules/packages.nix
        ./modules/nvidia.nix
        ./modules/hyprland.nix
        ./modules/steam.nix
        inputs.musnix.nixosModules.musnix
      ];
    };
  };
}
