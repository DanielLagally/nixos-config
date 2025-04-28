{
  description = "main system config";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
      inputs.nixpkgs.follows = "nixpkgs_unstable";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    musnix  = { url = "github:musnix/musnix"; };
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, ... } @ inputs:
  let
    system = builtins.currentSystem or "x86_64-linux";
    #hostname = builtins.replaceStrings ["\n"] [""] (builtins.readFile "/etc/hostname");
    unstable = import nixpkgs_unstable {
      inherit system;
      config.allowUnfree = true;
    };
    stable = import nixpkgs_stable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.tower = nixpkgs_unstable.lib.nixosSystem {
      specialArgs = { inherit inputs; inherit stable; inherit unstable; inherit system; };
      inherit system;
      modules = [
        ./tower/configuration.nix
      ];
    };

    # Default configuration for current machine
    # defaultPackage.${system} = self.nixosConfigurations.${hostname}.config.system.build.toplevel;
  };
}
