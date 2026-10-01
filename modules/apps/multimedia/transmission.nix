{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = [pkgs.transmission_4-gtk];
  };
}
