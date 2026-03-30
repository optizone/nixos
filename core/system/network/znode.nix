{ host, hostId, ... }:
{
  networking = {
    hostName = "${host}";
    hostId = "${hostId}";

    firewall = {
      enable = true;

      allowedTCPPorts = [
        22
        80
        443
      ];
    };
  };
}
