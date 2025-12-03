{
  description = "main system config";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";    
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    hyprtasking = {
      url = "github:raybbian/hyprtasking";
      inputs.hyprland.follows = "hyprland";
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
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, home-manager, nixos-hardware, nix-darwin, determinate, ... } @ inputs:
  let
    system = "x86_64-linux";
    unstable = import nixpkgs_unstable {
      inherit system;
      config.allowUnfree = true;
    };
    unstableWithCuda = import nixpkgs_unstable {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
    };
    stable = import nixpkgs_stable {
      inherit system;
      config.allowUnfree = true;
    };
    stdenv = unstable.gccStdenv;
    llvm_env = unstable.llvmPackages_20.stdenv;
  in
  {
    nixosConfigurations = {
      tower = nixpkgs_unstable.lib.nixosSystem {
        specialArgs = { inherit inputs stable unstable unstableWithCuda system home-manager; };
        inherit system;
        modules = [
          ./tower/configuration.nix
          chaotic.nixosModules.default
        ];
      };
            
      think = nixpkgs_unstable.lib.nixosSystem {
        specialArgs = { inherit inputs stable unstable system home-manager; };
        inherit system;
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t480
          ./think/configuration.nix
        ];
      };
    };
    darwinConfigurations.Daniels-MacBook-Pro = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs stable unstable system home-manager; };
      modules = [
        inputs.determinate.darwinModules.default (
          ./mac/configuration.nix
        )
      ];
    };
    devShells.${system} = {
      c = unstable.mkShell.override { stdenv = llvm_env; } {
        nativeBuildInputs = [
          unstable.llvmPackages_20.clang-tools
          unstable.llvmPackages_20.llvm-manpages
          unstable.llvmPackages_20.clang-manpages
          unstable.llvmPackages_20.libllvm
          unstable.lldb_20
          unstable.gnumake
          unstable.man-pages
          unstable.man-pages-posix
          unstable.cmake
          unstable.valgrind
          unstable.systemc
        ];
      };
      rust = unstable.mkShell.override { stdenv = llvm_env; } {
        nativeBuildInputs = [
          unstable.lldb_20
          unstable.rust-analyzer
          unstable.rustc
          unstable.cargo
          unstable.clippy
          unstable.rustfmt
        ];
      };
      python = unstable.mkShell {
        nativeBuildInputs = [
          unstable.python312
          unstable.python312Packages.pip
        ];
      };
      java = unstable.mkShell {
        nativeBuildInputs = [
          unstable.jetbrains.idea-ultimate
          unstable.jetbrains.jdk-no-jcef-17
          unstable.protobuf
          unstable.gradle
          unstable.bazel_7
        ];
      };
    };
  };
}
