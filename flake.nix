{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    helix.url   = "github:helix-editor/helix/master";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # Keeps home-manager's nixpkgs in sync with the system's,
      # preventing subtle version mismatches.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix

          # Wire home-manager into the NixOS build
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;  # share system nixpkgs + allowUnfree
            home-manager.useUserPackages  = true;  # packages land in the user profile

            home-manager.backupFileExtension = "backup";

            # Make "inputs" available as a parameter inside home.nix
            # (needed to reference inputs.helix.packages.*.helix)
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.parrhasius = import ./home;
          }
        ];
      };
    };
  };
}
