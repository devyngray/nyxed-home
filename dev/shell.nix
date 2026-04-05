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
    home = {
      sessionVariables = {
        PAGER = "less -FR";
      };

      packages = with pkgs; [
        # clipboard
        wl-clipboard
        xclip

        # global python for repl
        python3
        uv

        # utils
        file
        zip
        unzip
        ripgrep
        rclone
      ];
    };

    programs = {
      bash.enable = true;

      nushell = {
        enable = true;
        extraConfig = ''
          let carapace_completer = {|spans|
            carapace $spans.0 nushell ...$spans | from json
          }

          $env.config = {
            show_banner: false
            table: {
              mode: compact
            }
            completions: {
              case_sensitive: false
              quick: true
              partial: true
              algorithm: fuzzy
              external: {
                enable: true
                max_results: 100
                completer: $carapace_completer
              }
            }
          }
        '';
      };

      carapace = {
        enable = true;
        enableNushellIntegration = false;
      };

      # better cd aliased to z
      zoxide = {
        enable = true;
        enableNushellIntegration = true;
      };

      # file explorer
      yazi = {
        enable = true;
        enableNushellIntegration = true;
      };

      # direnv
      direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
        silent = true;
      };
    };
  };
}
