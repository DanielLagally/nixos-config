{
  description = "Flake for my main desktop machine";
  inputs = {
    toplevel.url = "../../inputs";
  };
  outputs = inputs': let inputs = inputs'.toplevel.inputs; in with inputs; {
    nixosConfigurations.default = let system = "x86_64-linux"; in nixpkgs-unstable.lib.nixosSystem {
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
      specialArgs = { inherit inputs system home-manager; };
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-t480
        determinate.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
