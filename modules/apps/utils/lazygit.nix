{username, ...}: {
  home-manager.users.${username} = {
    programs.lazygit = {
      enable = true;

      settings = {
        gui.border = "single";
      };
    };
  };
}
