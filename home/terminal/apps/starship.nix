{ lib, ... }:
{
  programs.starship = {
    enable = true;

    # enableBashIntegration = true;
    # enableZshIntegration = false;
    # enableNushellIntegration = false;
    # enableFishIntegration = true;

    settings = {
      format = lib.concatStrings [
        # "$os"
        "$nix_shell"
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$c"
        "$rust"
        "$golang"
        "$php"
        "$java"
        "$kotlin"
        "$haskell"
        "$python"
        "$docker_context"
        "$conda"
        "$time"
        "$cmd_duration"
        "$line_break$character"
      ];

      palette = "gruvbox_dark";
      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_blue_light = "#83a598";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };

      os = {
        disabled = false;
        style = "bold fg:#a89984";
        symbols = {
          NixOS = " ";
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          EndeavourOS = "";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          Pop = "";
        };
      };

      username = {
        show_always = true;
        style_user = "fg:#a89984";
        style_root = "fg:color_orange";
        format = "as [$user ]($style)";
      };

      hostname = {
        style = "fg:color_blue_light";
        # ssh_only = false;
        format = "on [$hostname ]($style)";
      };

      directory = {
        style = "fg:color_orange";
        format = "in [$path]($style) ";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          # Documents = "󰈙 ";
          # documents = "󰈙 ";
          # Downloads = " ";
          # downloads = " ";
          # Music = "󰝚 ";
          # Pictures = " ";
          # pictures = " ";
          # code = "󰲋 ";
          # vms = "󰋊 ";
        };
      };

      git_branch = {
        symbol = "";
        format = "[$symbol $branch ](bold fg:color_purple)";
      };

      git_status = {
        format = "[($all_status$ahead_behind )](fg:color_purple)";
      };

      nix_shell = {
        style = "bold fg:color_orange";
        format = "[<$name> ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        format = "finished at [$time](fg:color_green) ";
      };

      cmd_duration = {
        format = "took [$duration](fg:color_blue)";
        disabled = false;
      };

      line_break = {
        disabled = false;
      };

      character = {
        disabled = false;

        success_symbol = "[\\$](bold fg:color_green)";
        error_symbol = "[\\$](bold fg:color_red)";
        vimcmd_symbol = "[\\$](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[\\$](bold fg:color_purple)";
        vimcmd_replace_symbol = "[\\$](bold fg:color_purple)";
        vimcmd_visual_symbol = "[\\$](bold fg:color_yellow)";
      };

      c = {
        symbol = " ";
        style = "fg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_blue)]($style)";
      };

      rust = {
        symbol = "rust ";
        style = "fg:color_purple";
        format = "[[ $symbol( $version) ](fg:color_purple)]($style)";
      };

      golang = {
        symbol = "";
        style = "fg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_blue)]($style)";
      };

      php = {
        symbol = "";
        style = "fg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_blue)]($style)";
      };

      java = {
        symbol = "";
        style = "fg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_blue)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "fg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_blue)]($style)";
      };

      haskell = {
        symbol = "";
        style = "fg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_blue)]($style)";
      };

      python = {
        symbol = "";
        style = "fg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_blue)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:color_bg3";
        format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
      };

      conda = {
        style = "bg:color_bg3";
        format = "[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)";
      };

    };
  };
}
