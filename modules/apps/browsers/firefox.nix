{
  pkgs,
  username,
  ...
}: {
  home-manager.users.${username} = {
    # TODO: config
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
        pipewireSupport = true;
      }) {};
    };
  };
}
