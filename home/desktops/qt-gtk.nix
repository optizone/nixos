{
  pkgs,
  font,
  lib,
  ...
}:
{
  # ================ COMMON ====================

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.bigblue-terminal

    # needed for CV
    source-sans-pro
    source-sans
    roboto
    font-awesome

    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts-color-emoji

    gruvbox-kvantum
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
  ];

  home.pointerCursor = {
    name = "Simp1e";
    package = pkgs.simp1e-cursors;
    size = 24;
  };

  # ============================================

  # ================== QT ======================

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "kvantum";
    };

    # TODO:
    # qt5ct.settings = { Appearance = { style = "kvantum"; }; };
    # qt6ctSettings = { Appearance = { style = "kvantum"; }; };
  };

  xdg.configFile."Kvantum/Gruvbox-Dark-Brown".source =
    "${pkgs.gruvbox-kvantum}/share/Kvantum/Gruvbox-Dark-Brown";

  xdg.configFile."Kvantum/kvantum.kvconfig".text = lib.generators.toINI { } {
    General = {
      theme = "Gruvbox-Dark-Brown";
    };
  };

  # ============================================

  # ================== GTK =====================

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

    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  # ============================================

}
