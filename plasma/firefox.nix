{ config, lib, ... }:
let
  cfg = config.nyxed-home-plasma;
in
{
  config = lib.mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}
