{
  pkgs,
  fontMono,
  username,
  ...
}: {
  services = {
    gvfs.enable = true;

    gnome = {
      tinysparql.enable = true;
      gnome-keyring.enable = true;
    };

    dbus.enable = true;
    fstrim.enable = true;

    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];
  };

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      evince # pdf
      file-roller # archive
      gnome-text-editor # gedit
    ];

    dconf.settings = {
      "org/gnome/TextEditor" = {
        custom-font = "${fontMono} 15";
        highlight-current-line = true;
        indent-style = "space";
        restore-session = false;
        show-grid = false;
        show-line-numbers = true;
        show-right-margin = false;
        style-scheme = "builder-dark";
        style-variant = "dark";
        tab-width = "uint32 4";
        use-system-font = false;
        wrap-text = false;
      };
    };
  };
}
