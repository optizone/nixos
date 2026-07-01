{pkgs, ...}: {
  home.packages = with pkgs; [swaynotificationcenter];

  xdg.configFile."swaync/style.css".source = ./two/style.css;
  xdg.configFile."swaync/config.json".source = ./two/config.json;
}
