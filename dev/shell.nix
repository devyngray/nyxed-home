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
         table: {
           mode: "compact",
         },
         show_banner: false,
         completions: {
         case_sensitive: false # case-sensitive completions
         quick: true    # set to false to prevent auto-selecting completions
         partial: true    # set to false to prevent partial filling of the prompt
         algorithm: "fuzzy"    # prefix or fuzzy
         external: {
         # set to false to prevent nushell looking into $env.PATH to find more suggestions
             enable: true 
         # set to lower can improve completion performance at the cost of omitting some options
             max_results: 100 
             completer: $carapace_completer # check 'carapace_completer' 
           }
         }
        } 
      '';
    };

    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    home.sessionVariables = {
      PAGER = "less -FR";
    };

    home.packages = with pkgs; [
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

    # openai codex
    programs.codex = {
      enable = cfg.aiEnable;
    };

    # claude code
    programs.claude-code = {
      enable = cfg.aiEnable;
    };
  };
}
