{pkgs, ...}: let
  w50 = "monitor_w*0.5";
  h50 = "monitor_h*0.5";

  centerFloat = wr: hr: "[float true; center true; size monitor_w*${builtins.toString wr} monitor_h*${builtins.toString hr}]";

  positionedFloat = xr: yr: wr: hr: "[float true; move monitor_w*${builtins.toString xr} monitor_h*${builtins.toString yr}; size monitor_w*${builtins.toString wr} monitor_h*${builtins.toString hr}]";
in {
  home.packages = with pkgs; [
    playerctl
    wl-clipboard
  ];

  wayland.windowManager.hyprland = {
    # enable = true;
    # systemd.enable = true;

    settings = {
      # autostart
      exec-once = [
        # "hash dbus-update-activation-environment 2>/dev/null"
        "dbus-update-activation-environment --all --systemd"
        "systemctl --user import-environment"

        "nm-applet &"
        "poweralertd &"
        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "waybar &"
        "swaync &"
        "hyprctl setcursor Simp1e 24 &"
        "awww-daemon &"
      ];

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = true;
        mouse_refocus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        # "SUPER" = "SUPER";
        # "kitty" = "kitty";
        layout = "dwindle";
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "0xffbdae93";
        "col.inactive_border" = "0xff665c54";
      };

      cursor = {
        inactive_timeout = 0.100;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        # new_window_takes_over_fullscreen = 2;
        middle_click_paste = false;
      };

      dwindle = {
        force_split = 2;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        # pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_status = "master";
        special_scale_factor = 1;
      };

      decoration = {
        rounding = 0;
        blur.enabled = false;
        shadow.enabled = false;
      };

      animations.enabled = false;

      binds = {
        movefocus_cycles_fullscreen = true;
        workspace_back_and_forth = false;
      };

      bind = [
        "SUPER, F1, exec, rofi-show-keybinds"

        "SUPER, Return, exec, ${centerFloat 0.5 0.5} kitty"
        "SUPER, Q, killactive,"

        "SUPER, SPACE, fullscreen, 1"
        "SUPER SHIFT, SPACE, fullscreen, 0"

        "SUPER, F, exec, toggle-float"
        # FIXME: env hack
        "SUPER SHIFT, D, exec, QT_QPA_PLATFORMTHEME=qt5ct rofi -show drun"
        "SUPER SHIFT, N, exec, kitty --session zroot"
        "SUPER SHIFT, C, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy"
        "SUPER SHIFT, M, exec, ${centerFloat 0.5 0.5} kitty calcure"
        "SUPER SHIFT, B, exec, ${centerFloat 0.5 0.5} kitty htop"
        "SUPER SHIFT, P, exec, ${positionedFloat 0.025 0.55 0.475 0.4} kitty rmpc"
        "SUPER SHIFT, W, exec, ${centerFloat 0.5 0.5} waypaper"
        "SUPER SHIFT, Return, exec, ${centerFloat 0.5 0.5} EDITOR=nvim kitty yazi"
        "SUPER SHIFT, O, exec, qutebrowser"
        "SUPER SHIFT, V, exec, ${centerFloat 0.5 0.5} pavucontrol"

        "SUPER, X, exec, rofi-power-menu"
        "SUPER, Z, exec, systemctl suspend"
        "SUPER SHIFT, Z, exec, systemctl hibernate"

        "SUPER, P, pseudo,"
        # "SUPER, S, togglesplit,"
        "SUPER, B, exec, toggle-waybar"
        "SUPER, C, exec, hyprpicker -a"
        "SUPER, N, exec, swaync-client -t -sw"

        # locking
        "SUPER, Escape, exec, swaylock"
        "ALT, Escape, exec, hyprlock"

        # screenshot
        ",Print, exec, screenshot --copy"
        "SUPER, Print, exec, screenshot --save"
        "SUPER SHIFT, Print, exec, screenshot --swappy"

        # switch focus
        "SUPER, left,  movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up,    movefocus, u"
        "SUPER, down,  movefocus, d"
        "SUPER, h, movefocus, l"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"
        "SUPER, l, movefocus, r"

        "SUPER, TAB, exec, hyprctl dispatch focuswindow floating"
        "SUPER SHIFT, TAB, exec, hyprctl dispatch focuswindow tiled"

        "SUPER, w, alterzorder, top"

        # workspace control
        "SUPER, 1, focusworkspaceoncurrentmonitor, 1"
        "SUPER, 2, focusworkspaceoncurrentmonitor, 2"
        "SUPER, 3, focusworkspaceoncurrentmonitor, 3"
        "SUPER, 4, focusworkspaceoncurrentmonitor, 4"
        "SUPER, 5, focusworkspaceoncurrentmonitor, 5"
        "SUPER, 6, focusworkspaceoncurrentmonitor, 6"
        "SUPER, 7, focusworkspaceoncurrentmonitor, 7"
        "SUPER, 8, focusworkspaceoncurrentmonitor, 8"
        "SUPER, 9, focusworkspaceoncurrentmonitor, 9"
        "SUPER, 0, focusworkspaceoncurrentmonitor, 10"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # window control
        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"
        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, j, movewindow, d"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, l, movewindow, r"

        "SUPER CTRL, left, resizeactive, -80 0"
        "SUPER CTRL, right, resizeactive, 80 0"
        "SUPER CTRL, up, resizeactive, 0 -80"
        "SUPER CTRL, down, resizeactive, 0 80"
        "SUPER CTRL, h, resizeactive, -80 0"
        "SUPER CTRL, j, resizeactive, 0 80"
        "SUPER CTRL, k, resizeactive, 0 -80"
        "SUPER CTRL, l, resizeactive, 80 0"

        "SUPER ALT, left, moveactive,  -80 0"
        "SUPER ALT, right, moveactive, 80 0"
        "SUPER ALT, up, moveactive, 0 -80"
        "SUPER ALT, down, moveactive, 0 80"
        "SUPER ALT, h, moveactive,  -80 0"
        "SUPER ALT, j, moveactive, 0 80"
        "SUPER ALT, k, moveactive, 0 -80"
        "SUPER ALT, l, moveactive, 80 0"

        # media and volume controls
        # ",XF86AudioMute,exec, pamixer -t"
        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop,exec, playerctl stop"

        "SUPER, mouse_down, workspace, e-1"
        "SUPER, mouse_up, workspace, e+1"
      ];

      # mouse binding
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      # windowrule
      windowrule = let
        w50 = "monitor_w*0.5";
        h50 = "monitor_h*0.5";
      in [
        "match:class ^(mpv)$, float true, size ${w50} ${h50}, center true"
        "match:class ^(rofi)$, pin true"
        "match:class ^(waypaper)$, float true, size ${w50} ${h50}, center true, pin true"
        "match:title ^(Transmission)$, float true, size ${w50} ${h50}, center true"
        "match:title ^(Volume Control)$, float true, size ${w50} ${h50}, center true"

        "match:class ^(evince)$, float true, size ${w50} ${h50}, center true"

        "match:title ^(Picture-in-Picture)$, float true"
        "match:class ^(org.gnome.Calculator)$, float true, center true"
        # TODO: does not resize when called from rofi
        "match:class ^(waypaper)$, float true, center true, size ${w50} ${h50}"
        "match:class ^(org.pulseaudio.pavucontrol)$, float true"
        "match:class ^(SoundWireServer)$, float true"
        "match:class ^(file_progress)$, float true"
        "match:class ^(confirm)$, float true"
        "match:class ^(dialog)$, float true"
        "match:class ^(download)$, float true"
        "match:class ^(notification)$, float true"
        "match:class ^(error)$, float true"
        "match:class ^(confirmreset)$, float true"
        "match:title ^(Open File)$, float true"
        "match:title ^(File Upload)$, float true"
        "match:title ^(branchdialog)$, float true"

        # No border when only one tiled window on workspace
        "match:float false, match:workspace w[t1], border_size 0"
        "match:float false, match:workspace w[t1], rounding 0"
      ];

      # No gaps when only
      workspace = [
        "w[t1], gapsout:0, gapsin:0"
        "w[tg1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
    };

    extraConfig = "
      monitor=,preferred,auto,1

      xwayland {
        force_zero_scaling = true
      }
    ";
  };
}
