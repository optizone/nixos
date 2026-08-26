{pkgs, ...}: {
  imports = [
    ./browsers/firefox.nix
    ./browsers/librewolf.nix
    ./browsers/google-chrome.nix
    ./browsers/qutebroser.nix

    ./desktops/default.nix

    ./gui-apps/electrum.nix

    ./gui-apps/file-managers/nemo.nix

    ./gui-apps/images/gimp.nix
    ./gui-apps/images/inkscape.nix
    ./gui-apps/images/oculante.nix

    ./gui-apps/multimedia/kdenlive.nix
    ./gui-apps/multimedia/mpv.nix
    ./gui-apps/multimedia/transmission.nix
    ./gui-apps/multimedia/spotify.nix

    ./gui-apps/office/libreoffice.nix

    ./gui-apps/social/telegram.nix
    ./gui-apps/social/thunderbird.nix

    ./scripts

    ./terminal/apps
    ./terminal/emulators/kitty
    ./terminal/shells/fish.nix

    ./ui/kanshi.nix
    ./ui/wallpapers.nix
    ./ui/waypaper.nix

    ./git.nix
    ./ssh.nix
    ./xdg-mimes.nix

    ./ai.nix
  ];

  home.packages = with pkgs; [
    libnotify
    kicad
    mpv
    xdg-utils

    pavucontrol
    wiremix
    gnome-calculator
    wineWowPackages.wayland

    caligula # TUI disk burner
    pastel # CLI colors
    calcure # TUI calendar

    kiwix
  ];
}
