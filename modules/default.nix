{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      libnotify

      wineWowPackages.wayland
    ];
  };
}
