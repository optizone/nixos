{ ... }:
{
  imports = [
    ./system/network/znode.nix
    ./system/settings.nix
    ./system/sops.nix

    ./programs/nh.nix

    ./virtualization/host.nix
  ];
}
