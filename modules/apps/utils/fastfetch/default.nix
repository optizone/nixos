{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    home.packages = with pkgs; [fastfetch];

    xdg.configFile."fastfetch/art".source = ./art/arch;
    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
