{ ... }:
{
  imports = [
    ../laptop-common/default.nix
    ./hardware-configuration.nix
    ./user.nix
  ];
}
