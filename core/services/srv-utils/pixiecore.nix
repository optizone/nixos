_: {
  services.pixiecore = {
    enable = true;

    mode = "quick";
    quick = "xyz";

    dhcpNoBind = true;
    debug = true;
    openFirewall = true;
  };
}
