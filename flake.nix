{
  description = "main system config";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";    
    home-manager = {
      url =  "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    musnix  = { url = "github:musnix/musnix"; };
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, home-manager, ... } @ inputs:
  let
    system = builtins.currentSystem or "x86_64-linux";
    unstable = import nixpkgs_unstable {
      inherit system;
      config.allowUnfree = true;
    };
    stable = import nixpkgs_stable {
      inherit system;
      config.allowUnfree = true;
    };
    stdenv = unstable.llvmPackages_20.stdenv;
  in
  {
    nixosConfigurations.tower = nixpkgs_unstable.lib.nixosSystem {
      specialArgs = { inherit inputs stable unstable system home-manager; };
      inherit system;
      modules = [
        ./tower/configuration.nix
      ];
    };
    nixosConfigurations.think = nixpkgs_unstable.lib.nixosSystem {
      specialArgs = { inherit inputs stable unstable system home-manager; };
      inherit system;
      modules = [
        ./think/configuration.nix
      ];
    };      
    devShells.${system}."c" = unstable.mkShell.override {
      inherit stdenv;
    } {
      nativeBuildInputs = [
        unstable.llvmPackages_20.clang-tools
        unstable.llvmPackages_20.llvm-manpages
        unstable.llvmPackages_20.clang-manpages
        unstable.lldb_20
        unstable.gnumake
        unstable.man-pages
        unstable.man-pages-posix
        unstable.cmake
      ];
    };
  };
}
