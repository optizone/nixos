{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  documentation = {
    enable = true;
    man.cache.enable = true;
    dev.enable = true;
    nixos.enable = true;
    nixos.includeAllModules = true;
  };
}
