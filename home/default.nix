{ pkgs, ... }:
{
  imports = [
    ./browsers/firefox.nix
    ./browsers/librewolf.nix
    ./browsers/google-chrome.nix
    ./browsers/qutebroser.nix

    ./desktops/default.nix

    ./gui-apps/obsidian.nix
    ./gui-apps/file-managers/nemo.nix
    ./gui-apps/images/gimp.nix
    ./gui-apps/images/inkscape.nix
    ./gui-apps/images/oculante.nix
    ./gui-apps/multimedia/mpv.nix
    ./gui-apps/multimedia/spotify.nix
    ./gui-apps/office/libreoffice.nix
    ./gui-apps/social/telegram.nix

    ./scripts

    ./terminal/apps
    ./terminal/emulators/kitty.nix
    ./terminal/shells/fish.nix

    ./ui/kanshi.nix
    ./ui/wallpapers.nix
    ./ui/waypaper.nix

    ./git.nix
    ./ssh.nix
    ./xdg-mimes.nix
  ];

  home.packages = with pkgs; [
    libnotify
    mpv
    xdg-utils

    pavucontrol
    gnome-calculator
    wineWowPackages.wayland

    # todo: package
    thunderbird

    kiwix
  ];
}
