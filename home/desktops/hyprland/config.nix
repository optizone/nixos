{ pkgs, ... }:
let
  w50 = "monitor_w*0.5";
  h50 = "monitor_h*0.5";

  centerFloat =
    wr: hr:
    ''[float true; center true; size monitor_w*${builtins.toString wr} monitor_h*${builtins.toString hr}]'';

  positionedFloat =
    xr: yr: wr: hr:
    "[float true; move monitor_w*${builtins.toString xr} monitor_h*${builtins.toString yr}; size monitor_w*${builtins.toString wr} monitor_h*${builtins.toString hr}]";
in
{
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
        "swww-daemon &"
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
        "$mainMod" = "SUPER";
        "$term" = "kitty";
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
        pseudotile = "yes";
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
        "$mainMod, F1, exec, rofi-show-keybinds"

        "$mainMod, Return, exec, $term"
        "$mainMod, Q, killactive,"

        "$mainMod, SPACE, fullscreen, 1"
        "$mainMod SHIFT, SPACE, fullscreen, 0"

        "$mainMod, F, exec, toggle-float"
        # FIXME: env hack
        "$mainMod SHIFT, D, exec, QT_QPA_PLATFORMTHEME=qt5ct rofi -show drun"
        "$mainMod SHIFT, N, exec, $term --session zroot"
        "$mainMod SHIFT, C, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy"
        "$mainMod SHIFT, M, exec, ${centerFloat 0.5 0.5} $term calcure"
        "$mainMod SHIFT, B, exec, ${centerFloat 0.5 0.5} $term btop"
        "$mainMod SHIFT, P, exec, ${positionedFloat 0.025 0.55 0.4 0.4} $term rmpc"
        "$mainMod SHIFT, W, exec, ${centerFloat 0.5 0.5} waypaper"
        # FIXME: env hack
        "$mainMod SHIFT, Return, exec, ${centerFloat 0.5 0.5} QT_QPA_PLATFORMTHEME=qt5ct EDITOR=$$EDITOR SHELL=$$SHELL $term yazi"
        "$mainMod SHIFT, O, exec, qutebrowser"
        "$mainMod SHIFT, V, exec, ${centerFloat 0.5 0.5} pavucontrol"

        "$mainMod, X, exec, rofi-power-menu"
        "$mainMod, Z, exec, systemctl suspend"

        "$mainMod, P, pseudo,"
        "$mainMod, S, togglesplit,"
        "$mainMod, B, exec, toggle-waybar"
        "$mainMod, C, exec, hyprpicker -a"
        "$mainMod, N, exec, swaync-client -t -sw"

        # locking
        "$mainMod, Escape, exec, swaylock"
        "ALT, Escape, exec, hyprlock"

        # screenshot
        ",Print, exec, screenshot --copy"
        "$mainMod, Print, exec, screenshot --save"
        "$mainMod SHIFT, Print, exec, screenshot --swappy"

        # switch focus
        "$mainMod, left,  movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up,    movefocus, u"
        "$mainMod, down,  movefocus, d"
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"

        "$mainMod, TAB, exec, hyprctl dispatch focuswindow floating"
        "$mainMod SHIFT, TAB, exec, hyprctl dispatch focuswindow tiled"

        "$mainMod, w, alterzorder, top"

        # workspace control
        "$mainMod, 1, focusworkspaceoncurrentmonitor, 1"
        "$mainMod, 2, focusworkspaceoncurrentmonitor, 2"
        "$mainMod, 3, focusworkspaceoncurrentmonitor, 3"
        "$mainMod, 4, focusworkspaceoncurrentmonitor, 4"
        "$mainMod, 5, focusworkspaceoncurrentmonitor, 5"
        "$mainMod, 6, focusworkspaceoncurrentmonitor, 6"
        "$mainMod, 7, focusworkspaceoncurrentmonitor, 7"
        "$mainMod, 8, focusworkspaceoncurrentmonitor, 8"
        "$mainMod, 9, focusworkspaceoncurrentmonitor, 9"
        "$mainMod, 0, focusworkspaceoncurrentmonitor, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # window control
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, l, movewindow, r"

        "$mainMod CTRL, left, resizeactive, -80 0"
        "$mainMod CTRL, right, resizeactive, 80 0"
        "$mainMod CTRL, up, resizeactive, 0 -80"
        "$mainMod CTRL, down, resizeactive, 0 80"
        "$mainMod CTRL, h, resizeactive, -80 0"
        "$mainMod CTRL, j, resizeactive, 0 80"
        "$mainMod CTRL, k, resizeactive, 0 -80"
        "$mainMod CTRL, l, resizeactive, 80 0"

        "$mainMod ALT, left, moveactive,  -80 0"
        "$mainMod ALT, right, moveactive, 80 0"
        "$mainMod ALT, up, moveactive, 0 -80"
        "$mainMod ALT, down, moveactive, 0 80"
        "$mainMod ALT, h, moveactive,  -80 0"
        "$mainMod ALT, j, moveactive, 0 80"
        "$mainMod ALT, k, moveactive, 0 -80"
        "$mainMod ALT, l, moveactive, 80 0"

        # media and volume controls
        # ",XF86AudioMute,exec, pamixer -t"
        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop,exec, playerctl stop"

        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod, mouse_up, workspace, e+1"
      ];

      # mouse binding
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # windowrule
      windowrule =
        let
          w50 = "monitor_w*0.5";
          h50 = "monitor_h*0.5";
        in
        [
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
