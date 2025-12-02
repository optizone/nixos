{
  username,
  ...
}:
{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  imports = [ ../default.nix ];
}
