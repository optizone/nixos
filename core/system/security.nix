_: {
  security = {
    rtkit.enable = true;

    sudo = {
      enable = true;
      extraConfig = ''
        Defaults lecture = never
      '';
    };

    pam.services = {
      swaylock = {};
      hyprlock = {};
    };
  };
}
