{username, ...}: {
  home-manager.users.${username} = {
    programs.thunderbird = {
      enable = true;

      profiles = {};
    };
  };
}
