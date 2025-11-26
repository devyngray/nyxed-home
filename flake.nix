{
  description = "Devyn's home-manager modules";

  outputs =
    { ... }:
    {
      homeManagerModules = {
        nyxed-home-dev = import ./dev;
        nyxed-home-plasma = import ./plasma;
      };
    };
}
