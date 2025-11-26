{ lib, ... }:
{
  imports = [
    ./desktop.nix
    ./ghostty.nix
    ./helix.nix
    ./shell.nix
    ./vcs.nix
  ];

  options.nyxed-home = {
    enable = lib.mkEnableOption "Enable nyxed-home home-manager module";
    desktopEnable = lib.mkEnableOption "Enable KDE Plasma desktop environment within nyxed-home" // {
      default = true;
    };
    username = lib.mkOption {
      type = lib.types.str;
      default = "devyn";
      description = "Linux username for home manager config";
    };
    vcsName = lib.mkOption {
      type = lib.types.str;
      default = "Devyn Gray";
      description = "Name used in jj config.toml for commits";
    };
    vcsEmail = lib.mkOption {
      type = lib.types.str;
      default = "devyngray@proton.me";
      description = "Email used in jj config.toml for commits";
    };
  };
}
