{ domain, ... }:
{
  services.grocy = {
    enable = true;
    hostName = "grocy.${domain}";

    nginx = {
      enableSSL = false;
    };
  };
}
