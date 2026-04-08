{
  description = "Devyn's home-manager modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      homeManagerModules = {
        nyxed-home-ai = import ./ai;
        nyxed-home-dev = import ./dev;
        nyxed-home-plasma = import ./plasma;
      };

      homeConfigurations.test = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          self.homeManagerModules.nyxed-home-dev
          {
            nyxed-home-dev.enable = true;
            home = {
              stateVersion = "24.11";
              username = "test";
              homeDirectory = "/home/test";
            };
          }
        ];
      };

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          nyxed-home-ai =
            (home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                self.homeManagerModules.nyxed-home-ai
                {
                  nyxed-home-ai.enable = true;
                  home = {
                    stateVersion = "24.11";
                    username = "ci";
                    homeDirectory = "/home/ci";
                  };
                }
              ];
            }).activationPackage;
          nyxed-home-dev =
            (home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                self.homeManagerModules.nyxed-home-dev
                {
                  nyxed-home-dev.enable = true;
                  home = {
                    stateVersion = "24.11";
                    username = "ci";
                    homeDirectory = "/home/ci";
                  };
                }
              ];
            }).activationPackage;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              home-manager.packages.${system}.home-manager
              pkgs.nixfmt
              pkgs.statix
              pkgs.deadnix
            ];
          };
        }
      );

      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          mkApp = drv: {
            type = "app";
            program = "${drv}/bin/${drv.name}";
          };
        in
        {
          fmt = mkApp (
            pkgs.writeShellApplication {
              name = "fmt";
              runtimeInputs = [
                pkgs.nixfmt
                pkgs.findutils
              ];
              text = ''
                find . -name '*.nix' -exec nixfmt "$@" {} +
              '';
            }
          );

          fmt-check = mkApp (
            pkgs.writeShellApplication {
              name = "fmt-check";
              runtimeInputs = [
                pkgs.nixfmt
                pkgs.findutils
              ];
              text = ''
                find . -name '*.nix' -exec nixfmt --check {} +
              '';
            }
          );

          lint = mkApp (
            pkgs.writeShellApplication {
              name = "lint";
              runtimeInputs = [
                pkgs.statix
                pkgs.deadnix
              ];
              text = ''
                statix check .
                deadnix .
              '';
            }
          );

          lint-fix = mkApp (
            pkgs.writeShellApplication {
              name = "lint-fix";
              runtimeInputs = [
                pkgs.statix
                pkgs.deadnix
              ];
              text = ''
                statix fix .
                deadnix -e .
              '';
            }
          );
        }
      );
    };
}
