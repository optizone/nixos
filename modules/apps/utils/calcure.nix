{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      calcure # TUI calendar
    ];
  };
}
