{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      caligula # TUI disk burner
    ];
  };
}
