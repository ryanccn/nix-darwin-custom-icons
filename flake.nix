{
  outputs = {self}: {
    darwinModules = {
      default = import ./module.nix;
    };
  };
}
