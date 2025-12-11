{ ... }:
{
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
            scale = 1.25;
          }
        ];
      }

      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
            scale = 1.25;
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
            scale = 1.25;
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
              criteria = "eDP-1";
              status = "enable";
              scale = 1.25;
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
            }
            {
              criteria = "DP-2";
              status = "enable";
            }
          ];
        };
      }
    ];
  };
}
