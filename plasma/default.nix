{ lib, ... }:
{
  imports = [
    ./plasma.nix
  ];

  options.nyxed-home-plasma = {
    enable = lib.mkEnableOption "Enable nyxed-home-plasma home-manager module";
  };
}
