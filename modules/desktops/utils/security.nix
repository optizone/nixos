_: {
  security = {
    rtkit.enable = true;

    pam.services = {
      swaylock = {};
      hyprlock = {};
    };
  };
}
