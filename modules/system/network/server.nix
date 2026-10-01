{
  host,
  hostId,
  ...
}: {
  networking.nftables.enable = true;

  networking = {
    hostName = "${host}";
    hostId = "${hostId}";

    firewall = {
      enable = false;

      allowedTCPPorts = [
        22
        80
        443
      ];
    };
  };
}
