{ pkgs, font, ... }:
{
  home.packages = with pkgs; [ rofi ];

  xdg.configFile = {
    "rofi/gruvbox-dark-soft.rasi".source = ./gruvbox-dark-soft.rasi;
    "rofi/config.rasi".text = ''@theme "gruvbox-dark-soft"'';
    "rofi/power-menu.rasi".source = ./power-menu.rasi;
    "rofi/shared/fonts.rasi".text = ''
      * {
          font: "${font} 10";
      }'';
    "rofi/shared/colors.rasi".text = ''
      * {
          background:     #32302FFF;
          background-alt: #3C3836FF;
          foreground:     #F7EDC4FF;
          selected:       #665C54FF;
          active:         #B8BB26FF;
          urgent:         #FB4934FF;
      }'';
  };
}
