{username, ...}: {
  home-manager.users.${username} = {
    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      theme = ./gruvbox-dark.yml;
    };
  };
}
