{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nyxed-home-dev;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.git
    ];

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = cfg.vcsName;
          email = cfg.vcsEmail;
        };

        ui.default-command = "shortlog";

        revset-aliases = {
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "unmerged(from)" = "::from ~ ::trunk()";
        };

        aliases = {
          shortlog = [
            "log"
            "-n"
            "20"
          ];
          a = [
            "log"
            "-r"
            "all()"
          ];
          b = [ "bookmark" ];
        };

        code.fsmonitor = "watchman";
      };
    };
  };
}
