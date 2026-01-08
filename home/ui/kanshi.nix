_: {
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.33;
          }
        ];
      }

      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-5";
            status = "enable";
          }
          {
            criteria = "DP-6";
            status = "enable";
          }
        ];
      }

      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-7";
            status = "enable";
          }
          {
            criteria = "DP-8";
            status = "enable";
          }
        ];
      }

      {
        profile = {
          name = "protei-work";
          outputs = [
            {
              criteria = "HDMI-A-1";
              status = "enable";
            }
            {
              criteria = "DP-2";
              status = "enable";
            }
            {
              criteria = "eDP-1";
              status = "enable";
              scale = 1.25;
            }
          ];
        };
      }
    ];
  };
}
