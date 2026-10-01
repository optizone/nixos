{username, ...}: {
  home-manager.users.${username} = {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;

      enableBashIntegration = false;
      enableNushellIntegration = false;
      enableZshIntegration = false;
    };
  };
}
