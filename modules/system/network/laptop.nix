{
  pkgs,
  host,
  hostId,
  ...
}: {
  networking.nftables.enable = true;

  networking = {
    hostName = "${host}";
    hostId = "${hostId}";

    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    firewall = {
      enable = true;

      allowedTCPPorts = [];

      allowedUDPPorts = [];
    };
  };

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
