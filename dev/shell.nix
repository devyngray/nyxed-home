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
    programs.nushell.enable = true;
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
  };
}
