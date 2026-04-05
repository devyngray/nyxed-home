# nyxed-home

Declarative home-manager modules for composing dev environments across machines.

## Architecture

This is a Nix flake that exports `homeManagerModules`. It is **not** a standalone
home-manager configuration — consumers import individual modules and enable them.

### Module structure

Each directory is a module group:

```
dev/            → nyxed-home-dev
plasma/         → nyxed-home-plasma
```

- `default.nix` is the aggregator: imports submodules and defines
  `options.nyxed-home-<group>`
- Submodules are pure config — no options of their own
- All submodules follow this pattern:

```nix
{ pkgs, lib, config, ... }:
let
  cfg = config.nyxed-home-<group>;
in
{
  config = lib.mkIf cfg.enable {
    # ...
  };
}
```

### Adding a new module group

1. Create `<name>/default.nix` with imports and `options.nyxed-home-<name>`
2. Create submodule `.nix` files in the same directory
3. Add `nyxed-home-<name> = import ./<name>;` to `homeManagerModules` in `flake.nix`
4. If testable in CI, add a check to the `checks` output in `flake.nix`

### Adding a submodule to an existing group

1. Create `<group>/<name>.nix` using the `let cfg = ...` pattern above
2. Add `./<name>.nix` to the imports list in `<group>/default.nix`

## Conventions

- **Formatter**: `nixfmt` (nixfmt). Run `nix run .#fmt` to format all files.
- **Linting**: `statix` + `deadnix`. Run `nix run .#lint` to check.
- **VCS**: jujutsu (jj) is the primary VCS; the repo is colocated on GitHub.
- **Theme**: Gruvbox is used throughout (helix, ghostty, tmux).
- **Line length**: 120 columns.

## Dev workflow

```sh
nix run .#fmt          # format all .nix files
nix run .#fmt-check    # check formatting (CI runs this)
nix run .#lint         # statix + deadnix
nix run .#lint-fix     # auto-fix lint issues
nix flake check        # evaluate module checks
```

CI runs `fmt-check`, `lint`, and `flake check` — the same commands you run locally.
