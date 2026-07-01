{
  domain,
  host,
  ...
}: {
  services.avahi = {
    publish = {
      enable = true;
      userServices = true;
    };

    enable = true;
    hostName = host;
    nssmdns4 = true;
    openFirewall = true;
    domainName = domain;
  };
}
