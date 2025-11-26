{
  description = "Devyn's home-manager module";

  outputs =
    { ... }:
    {
      homeManagerModules.nyxed-home = import ./default.nix;
    };
}
