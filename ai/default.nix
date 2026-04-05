{ lib, ... }:
{
  imports = [
    ./claude.nix
  ];

  options.nyxed-home-ai = {
    enable = lib.mkEnableOption "Enable nyxed-home-ai home-manager module";
  };
}
