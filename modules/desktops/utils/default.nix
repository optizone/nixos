{
  username,
  pkgs,
  ...
}: {
  imports = [
    ./rofi
    ./swaync
    ./gnome.nix
    ./qt-gtk.nix
    ./swaylock.nix
    ./swayosd.nix
    ./waybar.nix
    ./xserver.nix
    ./ly.nix
    ./security.nix
    ./xdg-mimes.nix
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      libnotify

      pavucontrol
      wiremix

      wineWowPackages.wayland
    ];
  };
}
