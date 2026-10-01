{
  inputs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.file."Pictures/wallpapers" = {
      source = inputs.wallpapers;
      recursive = true;
    };
  };
}
