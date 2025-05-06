{
  description = "Basic C Flake";

  inputs = {
    nixpkgs_stable.url = "github:nixos/nixpkgs?ref=release-24.11";
    nixpkgs_unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable }:
  let
    system = "x86_64-linux";
    stable = nixpkgs_stable.legacyPackages.${system};
    unstable = nixpkgs_unstable.legacyPackages.${system};
    stdenv = unstable.llvmPackages_20.stdenv;
  in
  {
    devShells.${system}.default = unstable.mkShell.override {
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
