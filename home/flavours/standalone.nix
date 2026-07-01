{username, ...}: {
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  targets.genericLinux.enable = true;

  imports = [../default.nix];
}
