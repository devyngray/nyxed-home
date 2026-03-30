{ lib, config, ... }:
let
  cfg = config.nyxed-home-dev;
in
{
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "Gruvbox Dark";
        font-feature = "-calt, -liga, -dlig";
        shell-integration-features = "ssh-terminfo,ssh-env";
        mouse-hide-while-typing = true;
        command = "tmux new-session -As main";
      };
    };
  };
}
