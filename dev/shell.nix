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
    programs.bash.enable = true;

    programs.nushell = {
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

    programs.carapace = {
      enable = true;
      enableNushellIntegration = false;
    };

    home.sessionVariables = {
      PAGER = "less -FR";
    };

    home.packages = with pkgs; [
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

    # better cd aliased to z
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    # file explorer
    programs.yazi = {
      enable = true;
      enableNushellIntegration = true;
    };

    # direnv
    programs.direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
