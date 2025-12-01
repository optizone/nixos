{ pkgs, font, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts-color-emoji
  ];

  gtk = {
    enable = true;
    font = {
      name = "${font}";
      size = 12;
    };
    theme = {
      name = "Colloid-Green-Dark-Gruvbox";
      package = pkgs.colloid-gtk-theme.override {
        colorVariants = [ "dark" ];
        themeVariants = [ "green" ];
        tweaks = [
          "gruvbox"
          "rimless"
          "float"
        ];
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "green"; };
    };
    cursorTheme = {
      name = "Simp1e";
      package = pkgs.simp1e-cursors;
      size = 24;
    };
  };

  home.pointerCursor = {
    name = "Simp1e";
    package = pkgs.simp1e-cursors;
    size = 24;
  };
}
