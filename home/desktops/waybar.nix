{ pkgs, font, ... }:
let
  colors = rec {
    c_black = "#282828";
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

    c_warning = c_bryellow;
    c_critical = c_red;
    c_mode = c_black;
    c_unfocused = c_bg2;
    c_focused = c_braqua;
    c_inactive = c_purple;
    c_sound = c_brpurple;
    c_network = c_purple;
    c_memory = c_braqua;
    c_cpu = c_green;
    c_temp = c_brgreen;
    c_layout = c_bryellow;
    c_battery = c_aqua;
    c_date = c_black;
    c_time = c_white;
    c_homelab = c_blue;
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
      "hyprland/submap"
      "hyprland/workspaces"
      "custom/arrow10"
      "hyprland/window"
    ];

    modules-right = [
      "custom/arrow11"
      "custom/homelab"
      "custom/arrow9"
      "pulseaudio"
      "custom/arrow8"
      "network"
      "custom/arrow7"
      "memory"
      "custom/arrow6"
      "cpu"
      "custom/arrow5"
      "temperature"
      "custom/arrow4"
      "battery"
      "custom/arrow3"
      "hyprland/language"
      "custom/arrow2"
      "tray"
      "custom/weather"
      "clock"
      #"clock#date"
      #"custom/arrow1"
      #"clock#time"
    ];

    battery = {
      interval = 10;
      states = {
        warning = 30;
        critical = 15;
      };
      format-time = "{H}:{M:02}";
      format = "{icon} {capacity}% {time}";
      format-charging = " {capacity}% {time}";
      format-charging-full = " {capacity}%";
      format-full = "{icon} {capacity}%";
      format-alt = "{icon} {power}W";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      tooltip = true;
      tooltip-format = "{time}";
    };

    "custom/homelab" = {
      format = "󰒋 down";
      tooltip = false;
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

    cpu = {
      interval = 5;
      tooltip = false;
      format = " {usage}%";
      format-alt = " {avg_frequency} GHz";
      states = {
        warning = 70;
        critical = 90;
      };
      on-click-right = "hyprctl dispatch exec '[float; center; size monitor_w*0.5 monitor_h*0.5] kitty --title float_kitty btop'";
    };

    "hyprland/language" = {
      format = " {}";
      format-ru = "RU";
      format-en = "US";
      # keyboard-name = "at-translated-set-2-keyboard";
      on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
    };

    memory = {
      interval = 5;
      format = " {used:0.1f}G/{total:0.1f}G";
      format-alt = " {}%";
      states = {
        warning = 70;
        critical = 90;
      };
      tooltip = false;
      on-click-right = "hyprctl dispatch exec '[float; center; size monitor_w*0.5 monitor_h*0.5] kitty --title float_kitty btop'";
    };

    network = {
      interval = 5;
      format-wifi = " {essid} ({signalStrength}%)";
      format-ethernet = "󰈀 {ifname}";
      format-disconnected = "No connection";
      format-alt = "󰩠 {ipaddr}/{cidr}";
    };

    # disk = {
    #   path = "/";
    #   format = "<span foreground='${orange}'>󰋊 </span>{percentage_used}%";
    #   interval = 60;
    #   on-click-right = "hyprctl dispatch exec '[float; center; monitor_w*0.5 monitor_h*0.5] kitty --title float_kitty dust'";
    # };

    "hyprland/mode" = {
      format = "{}";
      tooltip = false;
    };

    "hyprland/window" = {
      format = "{}";
      max-length = 150;
      tooltip = false;
    };

    "hyprland/workspaces" = {
      disable-scroll-wraparound = true;
      smooth-scrolling-threshold = 4;
      enable-bar-scroll = true;
      on-click = "activate";
      format = "{name}";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-bluetooth = "󰂰 {volume}%";
      format-muted = "󰝟";
      format-icons = {
        headphone = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
        ];
      };
      scroll-step = 1;
      on-click = "pamixer -t";
      # TODO: floating center
      on-click-right = "hyprctl dispatch exec '[float; center; size monitor_w*0.5 monitor_h*0.5] pavucontrol'";
      tooltip = false;
    };

    temperature = {
      critical-threshold = 90;
      interval = 5;
      format = "{icon} {temperatureC}°";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      tooltip = false;
    };

    tray = {
      icon-size = 18;
      # spacing = 10;
    };

    "custom/arrow1" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow2" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow3" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow4" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow5" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow6" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow7" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow8" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow9" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow10" = {
      format = "";
      tooltip = false;
    };

    "custom/arrow11" = {
      format = "";
      tooltip = false;
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
      padding: 0;
      font-family: "${font}";
      font-size: 10pt;
    }

    /* The whole bar */
    #waybar {
      background: ${c_black};
      color: ${c_white};
      /*font-weight: bold;*/
    }

    /* Each module */
    #battery,
    #clock,
    #cpu,
    #language,
    #memory,
    #mode,
    #network,
    #pulseaudio,
    #temperature,
    #tray,
    #backlight,
    #idle_inhibitor,
    #disk,
    #user,
    #custom-homelab,
    #mpris {
      padding-left: 8pt;
      padding-right: 8pt;
    }

    /* Each critical module */
    #mode,
    #memory.critical,
    #cpu.critical,
    #temperature.critical,
    #battery.critical.discharging {
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
      animation-name: blink-critical;
      animation-duration: 1s;
    }

    /* Each warning */
    #network.disconnected,
    #memory.warning,
    #cpu.warning,
    #temperature.warning,
    #battery.warning.discharging {
      color: ${c_warning};
    }

    /* And now modules themselves in their respective order */

    /* Current sway mode (resize etc) */
    #mode {
      color: ${c_white};
      background: ${c_mode};
    }

    #custom-homelab {
      color: ${c_white};
      background: ${c_homelab};
    }

    /* Workspaces stuff */
    #workspaces button {
      /*font-weight: bold;*/
      padding-left: 2pt;
      padding-right: 2pt;
      color: ${c_white};
      background: ${c_unfocused};
    }

    /* Inactive (on unfocused output) */
    #workspaces button.visible {
      color: ${c_white};
      background: ${c_inactive};
    }

    /* Active (on focused output) */
    #workspaces button.focused {
      color: ${c_black};
      background: ${c_focused};
    }

    /* Contains an urgent window */
    #workspaces button.urgent {
      color: ${c_black};
      background: ${c_warning};
    }

    /* Style when cursor is on the button */
    #workspaces button:hover {
      background: ${c_black};
      color: ${c_white};
    }

    #window {
      margin-right: 35pt;
      margin-left: 35pt;
    }

    #pulseaudio {
      background: ${c_sound};
      color: ${c_black};
    }

    #network {
      background: ${c_network};
      color: ${c_white};
    }

    #memory {
      background: ${c_memory};
      color: ${c_black};
    }

    #cpu {
      background: ${c_cpu};
      color: ${c_white};
    }

    #temperature {
      background: ${c_temp};
      color: ${c_black};
    }

    #language {
      background: ${c_layout};
      color: ${c_black};
    }

    #battery {
      background: ${c_battery};
      color: ${c_white};
    }

    #tray {
      background: ${c_date};
    }

    /*#clock.date {
      background: @date;
      color: @white;
    }

    #clock.time {
      background: @time;
      color: @black;
    }*/
    #clock {
      background: ${c_date};
      color: ${c_white};
    }

    #custom-arrow1 {
      font-size: 11pt;
      color: ${c_time};
      background: ${c_date};
    }

    #custom-arrow2 {
      font-size: 11pt;
      color: ${c_date};
      background: ${c_layout};
    }

    #custom-arrow3 {
      font-size: 11pt;
      color: ${c_layout};
      background: ${c_battery};
    }

    #custom-arrow4 {
      font-size: 11pt;
      color: ${c_battery};
      background: ${c_temp};
    }

    #custom-arrow5 {
      font-size: 11pt;
      color: ${c_temp};
      background: ${c_cpu};
    }

    #custom-arrow6 {
      font-size: 11pt;
      color: ${c_cpu};
      background: ${c_memory};
    }

    #custom-arrow7 {
      font-size: 11pt;
      color: ${c_memory};
      background: ${c_network};
    }

    #custom-arrow8 {
      font-size: 11pt;
      color: ${c_network};
      background: ${c_sound};
    }

    #custom-arrow9 {
      font-size: 11pt;
      color: ${c_sound};
      background: ${c_homelab};
    }

    #custom-arrow10 {
      font-size: 11pt;
      color: ${c_unfocused};
      background: transparent;
    }

    #custom-arrow11 {
      font-size: 11pt;
      color: ${c_homelab};
      background: transparent;
    }
  '';
}
