{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nyxed-home-ai;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nodejs ];

    home.file = {
      ".claude/CLAUDE.md".text = ''
        # Personal preferences

        - Shell: Nushell (nu). Prefer Nushell idioms when writing shell snippets.
        - VCS: jujutsu (jj), not git. The repo may be colocated with git, but jj is the primary interface.
        - OS: NixOS / home-manager. Prefer declarative Nix solutions over imperative setup.
        - Editor: Helix.
        - Be concise. Skip preamble and filler.
      '';
    };
  };
}
