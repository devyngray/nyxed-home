# nyxed-home

Composable home-manager modules for setting up dev environments across machines.

## Modules

| Module | Description |
|--------|-------------|
| `nyxed-home-dev` | Dev tooling: Helix, Ghostty, tmux, Nushell, jujutsu, direnv, and language servers |
| `nyxed-home-plasma` | KDE Plasma desktop: Firefox, keybindings, touchpad, theming |

## Usage

Add this flake as an input and import the modules you need:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nyxed-home.url = "github:devyngray/nyxed-home";
  };

  outputs = { nixpkgs, home-manager, nyxed-home, ... }: {
    homeConfigurations.myhost = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        nyxed-home.homeManagerModules.nyxed-home-dev
        {
          nyxed-home-dev.enable = true;
          # optionally override:
          # nyxed-home-dev.vcsName = "Your Name";
          # nyxed-home-dev.vcsEmail = "you@example.com";
        }
      ];
    };
  };
}
```

## Development

```sh
nix run .#fmt          # format all .nix files
nix run .#fmt-check    # check formatting (CI runs this)
nix run .#lint         # statix + deadnix
nix run .#lint-fix     # auto-fix lint issues
nix flake check        # evaluate module checks
```
