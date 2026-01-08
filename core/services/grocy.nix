_: {
  services.grocy = {
    enable = true;
    hostName = "grocy.local";

    nginx = {
      enableSSL = false;
    };
  };
}
