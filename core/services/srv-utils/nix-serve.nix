_: {
  services.nix-serve = {
    enable = true;
    # secretKeyFile = "";
    port = 5000;
  };

  networking.firewall.allowedTCPPorts = [5000];

  # services.nginx = {
  #   enable = true;
  #   recommendedProxySettings = true;
  #   virtualHosts.cache = {
  #     locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
  #   };
  # };
  #
}
