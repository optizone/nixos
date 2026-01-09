{ pkgs, host, ... }:
{
  networking = {
    hostName = "${host}";
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    hosts = {
      "192.168.68.118" = [ "rpi5-k" ];
    };

    firewall = {
      enable = true;

      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
        57621
      ];

      allowedUDPPorts = [
        59010
        59011
        5353
      ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
