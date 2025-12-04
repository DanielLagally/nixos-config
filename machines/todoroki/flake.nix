{
  description = "Flake for my main desktop machine";
  inputs = {
    toplevel.url = "../../inputs";
  };
  outputs = inputs': let inputs = inputs'.toplevel.inputs; in with inputs; {
    darwinConfigurations.default = nix-darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
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
      };
      modules = [
        inputs.determinate.darwinModules.default (
          ./mac/configuration.nix
        )
      ];
    };
  };
}
