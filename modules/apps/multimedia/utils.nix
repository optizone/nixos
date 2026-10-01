{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      pamixer
      wiremix
      pavucontrol
    ];
  };
}
