{ fontMono, ... }:
{
  programs.kitty = {
    enable = true;

    # themeFile = "gruvbox-dark";
    themeFile = "gruvbox-dark-hard";

    font = {
      name = "${fontMono}";
      size = 11;
    };

    settings = {
      confirm_os_window_close = 2;
      background_opacity = "1";
      scrollback_lines = 10000;
      enable_audio_bell = false;
      mouse_hide_wait = 3;
      window_padding_width = 5;

      ## Tabs
      tab_title_template = "{index}";
      active_tab_font_style = "normal";
      inactive_tab_font_style = "normal";
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      active_tab_foreground = "#FBF1C7";
      active_tab_background = "#7C6F64";
      inactive_tab_foreground = "#FBF1C7";
      inactive_tab_background = "#3C3836";

      shell = "fish";
      shell_integration = "enabled";

      enabled_layouts = "grid";
    };


    keybindings = {
      ## Tabs
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      "alt+6" = "goto_tab 6";
      "alt+7" = "goto_tab 7";
      "alt+8" = "goto_tab 8";
      "alt+9" = "goto_tab 9";
      "alt+0" = "goto_tab 10";

      "alt+t" = "new_tab";
      "alt+q" = "close_tab";

      ## Windows
      "alt+w" = "close_window";
      "alt+enter" = "new_window";
      "alt+]" = "next_window";
      "alt+[" = "previous_window";

      ## Scrolling
      "alt+k" = "scroll_line_up";
      "alt+j" = "scroll_line_down";
      "alt+page_up" = "scroll_page_up";
      "alt+page_down" = "scroll_page_down";

      ## Unbind
      # "ctrl+shift+left" = "no_op";
      # "ctrl+shift+right" = "no_op";
    };

    settings.symbol_map =
      let
        mappings = [
          "U+23FB-U+23FE"
          "U+2B58"
          "U+E200-U+E2A9"
          "U+E0A0-U+E0A3"
          "U+E0B0-U+E0BF"
          "U+E0C0-U+E0C8"
          "U+E0CC-U+E0CF"
          "U+E0D0-U+E0D2"
          "U+E0D4"
          "U+E700-U+E7C5"
          "U+F000-U+F2E0"
          "U+2665"
          "U+26A1"
          "U+F400-U+F4A8"
          "U+F67C"
          "U+E000-U+E00A"
          "U+F300-U+F313"
          "U+E5FA-U+E62B"
        ];
      in
      (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
  };
}
