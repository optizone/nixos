{ pkgs, ... }:
{
  imports = [
    ./system/network/znode.nix
    ./system/settings.nix
    ./system/sops.nix

    ./programs/nh.nix

    ./virtualization/host.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    htop
    iotop
    iperf
    lsof
  ];
}
