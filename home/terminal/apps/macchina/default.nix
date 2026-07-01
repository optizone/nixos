{pkgs, ...}: {
  home.packages = [pkgs.macchina];

  xdg.configFile."macchina/themes/theme.toml".source = ./theme.toml;
}
