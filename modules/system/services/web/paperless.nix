{domain, ...}: {
  services.paperless = {
    enable = true;
    configureTika = true;
    port = 28981;
    inherit domain;
  };
}
