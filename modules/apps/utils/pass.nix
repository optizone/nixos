{
  username,
  pkgs,
  ...
}: {
  systemd.tmpfiles.rules = [
    "L /home/${username}/.password-store - - - - /zroot/ldata/secrets/pass"
  ];

  home-manager.users.${username} = {
    home.packages = [
      (pkgs.pass-nodmenu.withExtensions (e: [
        e.pass-otp
        e.pass-update
      ]))
    ];
  };
}
