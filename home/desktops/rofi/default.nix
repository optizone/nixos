{font, ...}: {
  imports = [
    ./scripts
  ];

  programs.rofi = {
    enable = true;

    theme = "gruvbox-dark-soft";
    font = "${font} 12";
    terminal = "kitty";
  };

  xdg.configFile = {
    "rofi/gruvbox-dark-soft.rasi".source = ./gruvbox-dark-soft.rasi;
    "rofi/power-menu.rasi".source = ./power-menu.rasi;
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
