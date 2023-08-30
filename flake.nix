{
  outputs = _: {
    darwinModules = {
      default = import ./module.nix;
    };
  };
}
