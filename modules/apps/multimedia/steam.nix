{
  pkgs,
  host,
  username,
  ...
}: {
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };

  environment.persistence."/zroot/ldata/persist/${host}" = {
    users.${username}.directories = [
      "/.local/share/Steam/"
    ];
  };
}
