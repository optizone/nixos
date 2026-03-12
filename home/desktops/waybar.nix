{
  pkgs,
  font,
  fontMono,
  ...
}:
let
  colors = rec {
    c_black = "#1d2021";
    c_red = "#cc241d";
    c_green = "#98971a";
    c_yellow = "#d79921";
    c_blue = "#458588";
    c_purple = "#b16286";
    c_aqua = "#689d6a";
    c_gray = "#a89984";
    c_brgray = "#928374";
    c_brred = "#fb4934";
    c_brgreen = "#b8bb26";
    c_bryellow = "#fabd2f";
    c_brblue = "#83a598";
    c_brpurple = "#d3869b";
    c_braqua = "#8ec07c";
    c_white = "#ebdbb2";
    c_bg2 = "#504945";
    c_orange = "#d65d0e";

    c_delim_workspace = c_orange;
    c_delim_tray = c_orange;
    c_warning = c_bryellow;
    c_critical = c_red;
    c_mode = c_black;
    c_unfocused = c_blue;
    c_focused = "#fb4934";
    c_inactive = c_brblue;
    c_sound = c_purple;
    c_network = c_blue;
    c_memory = c_purple;
    c_cpu = c_green;
    c_temp = c_red;
    c_layout = c_orange;
    c_battery = c_aqua;
    c_date = c_black;
    c_time = c_white;
  };
in
{
  programs.waybar.enable = true;

  home.packages = [
    pkgs.wttrbar
    pkgs.jq
  ];

  # config
  programs.waybar.settings.mainBar = {
    layer = "top";
    position = "top";

    modules-left = [
      "hyprland/workspaces"
      "custom/delim-workspaces"
      "pulseaudio"
      "network"
      "hyprland/language"
    ];

    modules-center = [ "clock" ];

    modules-right = [
      "memory"
      "cpu"
      "temperature"
      "battery"
      "custom/delim-tray"
      "tray"
      # "custom/weather"
    ];

    "hyprland/window" = {
      format = " $ {}";
      max-length = 150;
      tooltip = false;
    };

    "hyprland/workspaces" = {
      disable-scroll-wraparound = true;
      smooth-scrolling-threshold = 4;
      enable-bar-scroll = true;
      on-click = "activate";
      format = "{icon}{id}{icon}";
      format-icons = {
        default = " ";
        active = "|";
      };
    };

    "custom/delim-tray" = {
      tooltip = false;
      format = " # ";
    };

    "custom/delim-workspaces" = {
      tooltip = false;
      format = "# ";
    };

    pulseaudio = {
      format = "[VOL {volume}%]";
      format-muted = "[MUTED]";
      scroll-step = 1;
      on-click = "pamixer -t";
      on-click-right = "hyprctl dispatch exec '[float true; center true; size monitor_w*0.5 monitor_h*0.5] pavucontrol'";
      tooltip = false;
    };

    network = {
      interval = 5;
      format-wifi = "[WIFI {essid} ({signalStrength}%)]";
      format-ethernet = "[ETH]";
      # format-ethernet = "[ETH {ifname}]";
      format-disconnected = "[NO CONN]";
      format-alt = "[IP {ipaddr}/{cidr}]";
    };

    memory = {
      interval = 5;
      format = "[MEM {used:0.1f}G/{total:0.1f}G]";
      format-alt = "[MEM {}%]";
      states = {
        warning = 70;
        critical = 90;
      };
      tooltip = false;
      on-click-right = "hyprctl dispatch exec '[float; center; size monitor_w*0.5 monitor_h*0.5] kitty --title float_kitty btop'";
    };

    cpu = {
      interval = 5;
      tooltip = false;
      format = "[CPU {usage}%]";
      format-alt = "[CPU {avg_frequency} GHz]";
      states = {
        warning = 70;
        critical = 90;
      };
      on-click-right = "hyprctl dispatch exec '[float; center; size monitor_w*0.5 monitor_h*0.5] kitty --title float_kitty btop'";
    };

    temperature = {
      critical-threshold = 65;
      interval = 5;
      format = "[TEMP {temperatureC}°]";
      tooltip = false;
    };

    battery = {
      interval = 10;
      states = {
        warning = 30;
        critical = 15;
      };
      format = "[BAT {capacity}%]";
      format-charging = "[CHRG {capacity}%]";
      format-plugged = "[AC {capacity}%]";
      format-alt = "[PWR {power}W]";
      tooltip = true;
      tooltip-format = "{time}";
      format-time = "{H}:{M:02}";
    };

    "hyprland/language" = {
      format = "[{}]";
      format-ru = "RU";
      format-en = "US";
      # keyboard-name = "at-translated-set-2-keyboard";
      on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
    };

    "custom/weather" = {
      format = "{}°";
      tooltip = true;
      interval = 3600;
      exec = "wttrbar --nerd --location \"$(curl -s http://ip-api.com/json?fields=regionName | jq .regionName)\"";
      return-type = "json";
    };

    clock = {
      calendar = {
        format = {
          today = ''<span color = '${colors.c_green}'><b>{}</b></span>'';
          # TODO:
          weeks = "{:%W}";
        };
      };
      format = "{:%H:%M %d/%m/%Y}";
      tooltip = true;
      tooltip-format = "<tt><big>{calendar}</big></tt>";
    };

    # disk = {
    #   path = "/";
    #   format = "[DISK {used}/{total}]";
    #   interval = 60;
    #   on-click-right = "hyprctl dispatch exec '[float; center; monitor_w*0.5 monitor_h*0.5] kitty dust'";
    # };

    tray = {
      # TODO: custom icons (need png)
      # icons = {
      #   blueman = "b";
      # };
      # icon-size = 15;
      spacing = 11;
    };
  };

  # style.css
  programs.waybar.style = with colors; ''
    /* Reset all styles */
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      margin: 0;
      padding: 1pt;
      font-family: "${font}";
      font-size: 11pt;
    }

    #waybar {
      background: ${c_black};
      color: ${c_white};
      /*font-weight: bold;*/
    }

    #workspaces button {
      color: ${c_white};
      background: transparent;
    }

    #workspaces button.active {
      color: ${c_focused};
      background: transparent;
    }

    #pulseaudio {
      background: transparent;
      color: ${c_sound};
    }

    #network {
      background: transparent;
      color: ${c_network};
    }

    #memory {
      background: transparent;
      color: ${c_memory};
    }

    #cpu {
      background: transparent;
      color: ${c_cpu};
    }

    #temperature {
      background: transparent;
      color: ${c_temp};
    }

    #language {
      background: transparent;
      color: ${c_layout};
    }

    #battery {
      background: transparent;
      color: ${c_battery};
    }

    #clock {
      background: ${c_date};
      color: ${c_white};
    }

    #custom-delim-tray {
      background: transparent;
      color: ${c_delim_tray};
    }

    #custom-delim-workspaces {
      background: transparent;
      color: ${c_delim_workspace};
    }
  '';
}
