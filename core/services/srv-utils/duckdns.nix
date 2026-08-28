_: {
  sops.secrets."duckdns/optizone" = {};

  services.duckdns = {
    enable = true;
    domains = ["optizone"];
    tokenFile = "/run/secrets/duckdns/optizone";
  };
}
