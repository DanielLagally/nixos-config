{
  description = "main system config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";    
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = { self, nixpkgs-stable, nixpkgs-unstable, home-manager, nixos-hardware, nix-darwin, chaotic, determinate, ... } @ inputs:
  {
    nixosConfigurations = {
      tower = let system = "x86_64-linux"; in nixpkgs-unstable.lib.nixosSystem {
        # overwrite pkgs attribute
        pkgs = import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [
            (final: prev: {
              stable = import nixpkgs-stable {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };
              wthCuda = import nixpkgs-unstable {
                inherit system;
                config = {
                  allowUnfree = true;
                  cudaSupport = true;
                };
              };
            })
          ];
        };
      specialArgs = { inherit inputs system home-manager; };
        modules = [
          ./tower/configuration.nix
          chaotic.nixosModules.default
        ];
      };
            
      think = nixpkgs-unstable.lib.nixosSystem rec {
        system = "x86_64-linux";
        # overwrite pkgs attribute
        pkgs = import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [
            (final: prev: {
              stable = import nixpkgs-stable {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };
            })
          ];
        };
        specialArgs = {
          inherit inputs system home-manager;
          stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
          unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
        };
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t480
          ./think/configuration.nix
        ];
      };
    };
    darwinConfigurations.Daniels-MacBook-Pro = nix-darwin.lib.darwinSystem rec {
      system = "x86_64-linux";
      pkgs = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          (final: prev: {
            stable = import nixpkgs-stable {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };
          })
        ];
      };
      specialArgs = { 
        inherit inputs system home-manager;
        stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
        unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      };
      modules = [
        inputs.determinate.darwinModules.default (
          ./mac/configuration.nix
        )
      ];
    };
    # devShells.${system} = {
    #   c = unstable.mkShell.override { stdenv = llvm_env; } {
    #     nativeBuildInputs = [
    #       unstable.llvmPackages_20.clang-tools
    #       unstable.llvmPackages_20.llvm-manpages
    #       unstable.llvmPackages_20.clang-manpages
    #       unstable.llvmPackages_20.libllvm
    #       unstable.lldb_20
    #       unstable.gnumake
    #       unstable.man-pages
    #       unstable.man-pages-posix
    #       unstable.cmake
    #       unstable.valgrind
    #       unstable.systemc
    #     ];
    #   };
    #   rust = unstable.mkShell.override { stdenv = llvm_env; } {
    #     nativeBuildInputs = [
    #       unstable.lldb_20
    #       unstable.rust-analyzer
    #       unstable.rustc
    #       unstable.cargo
    #       unstable.clippy
    #       unstable.rustfmt
    #     ];
    #   };
    #   python = unstable.mkShell {
    #     nativeBuildInputs = [
    #       unstable.python312
    #       unstable.python312Packages.pip
    #     ];
    #   };
    #   java = unstable.mkShell {
    #     nativeBuildInputs = [
    #       unstable.jetbrains.idea-ultimate
    #       unstable.jetbrains.jdk-no-jcef-17
    #       unstable.protobuf
    #       unstable.gradle
    #       unstable.bazel_7
    #     ];
    #   };
    # };
  };
}
