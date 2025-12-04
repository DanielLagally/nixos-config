{
  description = "main system config";

  inputs = {
    himemori.url = "./machines/himemori";
    todoroki.url = "./machines/todoroki";
    roboco.url = "./machines/roboco";
  };
  outputs = inputs: {
    nixosConfigurations = {
      himemori = inputs.himemori.nixosConfigurations.default;
      roboco = inputs.roboco.nixosConfigurations.default;
    };
    darwinConfigurations = {
      todoroki = inputs.todoroki.darwinConfigurations.default;
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
  };
}
