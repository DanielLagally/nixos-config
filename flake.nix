{
  description = "main system config";

  inputs = {
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs_unstable";
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
    musnix = { url = "github:musnix/musnix"; };
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, home-manager, nixos-hardware, ... } @ inputs:
  let
    system = builtins.currentSystem or "x86_64-linux";
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
        specialArgs = { inherit inputs stable unstable unstableWithCuda system; };
        inherit system;
        modules = [
          ./tower/configuration.nix
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
      ocaml = unstable.mkShell.override {
        inherit stdenv ;
      } {
        nativeBuildInputs = [
          unstable.ocamlPackages.ocaml-lsp
          unstable.ocaml
          unstable.ocamlformat_0_26_1
          unstable.dune_3
          unstable.ocamlPackages.earlybird
          unstable.ocamlPackages.utop
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
      eist = unstable.mkShell.override {
        stdenv = llvm_env ;
      } {
        nativeBuildInputs = [
          # java
          unstable.jetbrains.idea-ultimate
          (unstable.jdk17.override {enableJavaFX = true;})
          unstable.gradle
          # python
          unstable.python312
          unstable.python312Packages.pip
          # c
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
          # other garbage
          unstable.bazel_7
          unstable.protobuf
          unstable.podman
          unstable.podman-compose
        ];

        venvDir = "/home/daniel/Dev/EIST/.venv";
        shellHook = ''
                    if [ ! -d $venvDir ]; then
                      python -m venv $venvDir
                    fi
                    source $venvDir/bin/activate
                  '';

        LD_LIBRARY_PATH="${unstable.gtk3}/lib:${unstable.glib}/lib";
      };
      gbs = unstable.mkShell {
        nativeBuildInputs = [
          unstable.gnumake
          unstable.gdb
          unstable.valgrind
          unstable.man-pages
          unstable.bash
          unstable.bash-completion
        ];
      };
      it-sec = unstable.mkShell {
        nativeBuildInputs = [
          (unstable.python3.withPackages (py-pkgs: with py-pkgs; [
            pip
          ]))
          unstable.basedpyright
          unstable.ruff
        ];
        shellHook = ''
                    if [ ! -d venv ]; then
                      python -m venv --system-site-packages venv
                    fi
                    source venv/bin/activate
                  '';
      };
    };
  };
}
