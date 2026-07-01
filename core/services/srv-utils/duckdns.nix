_: {
  sops.secrets."duckdns/optizone/token" = {};

  services.duckdns = {
    enable = true;
    domains = ["optizone"];
    tokenFile = "/run/secrets/duckdns/optizone/token";
  };
}
