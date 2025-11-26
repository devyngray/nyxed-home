{ lib, ... }:
{
  imports = [
    ./ghostty.nix
    ./helix.nix
    ./shell.nix
    ./vcs.nix
  ];

  options.nyxed-home-dev = {
    enable = lib.mkEnableOption "Enable nyxed-home-dev home-manager module";
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
