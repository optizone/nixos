{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pv
    zip
    unzip
  ];

  programs.fish = {
    enable = true;

    shellInit = ''
      ssh-add $HOME/.ssh/id_github &>/dev/null
      ssh-add $HOME/.ssh/id_work &>/dev/null
      ssh-add $HOME/.ssh/thinkpad &>/dev/null

    '';

    interactiveShellInit = ''
      # Suppresses fish's intro message
      set fish_greeting

      set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set -x MANROFFOPT -c
      set -g theme_nerd_fonts yes

      # TODO: global env var
      set -gx EDITOR nvim

      if not test $FISH_INIT_SUPPRESS_FASTFETCH;
        # fastfetch
        # pfetch
        macchina -t theme -o host -o machine -o kernel -o distribution -o packages -o processor -o memory
      end
    '';

    shellAliases = {
      "cd" = "z";
      "cd.." = "cd ..";
      "cd,," = "cd ..";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";

      ",," = "..";
      ",,," = "...";
      ",,,," = "....";
      ",,,,," = ".....";

      "ls" = "eza";
      "la" = "eza -a";
      "lla" = "eza -la";

      "ct" = "clean-trash-bin";
      "ns" = "NIXPKGS_ALLOW_UNFREE=1 FISH_INIT_SUPPRESS_FASTFETCH=TRUE nix-shell --command fish -p";
      "nd" = "NIXPKGS_ALLOW_UNFREE=1 FISH_INIT_SUPPRESS_FASTFETCH=TRUE nix develop --command fish";
      "ndl" =
        "git reset -- flake.nix flake.lock && git add --intent-to-add flake.nix flake.lock && nd && git update-index --assume-unchanged flake.nix flake.lock";
      "ndhide" =
        "git add --intent-to-add flake.nix flake.lock &&
        git update-index --assume-unchanged flake.nix flake.lock";
      "nv" = "nvim .";
      "kssh" = "kitten ssh";
    };

    functions = {
      extract = ''
        function extract
          switch $argv[1]
            case "*.tar.bz2"
              tar xjf $argv[1]

            case "*.tar.gz"
              tar xzf $argv[1]

            case "*.bz2"
              bunzip2 $argv[1]

            case "*.rar"
              unrar e $argv[1]

            case "*.gz"
              gunzip $argv[1]

            case "*.tar"
              tar xf $argv[1]

            case "*.tbz2"
              tar xjf $argv[1]

            case "*.tgz"
              tar xzf $argv[1]

            case "*.zip"
              unzip $argv[1]

            case "*.Z"
              uncompress $argv[1]

            case "*.7z"
              7z x $argv[1]

            case "*"
              echo "unknown extension: $argv[1]"
          end
        end
      '';

      backup = ''
        function backup --argument filename
            cp $filename $filename.bak
        end
      '';

      compress = ''
        function compress -d "Create an archive" -a filename
            if [ -e $filename ]
                echo "$filename already exists."
                return
            end
            set -l args $argv[2..-1]
            set -l size (du -ck $args | tail -n 1 | cut -f 1)

            echo "Creating a tarball of $filename"
            switch $filename
                case '*.tar.gz'
                    tar cf - $args | pv -p -s {$size}k | gzip -c > $filename
                case '*.tgz'
                    tar cf - $args | pv -p -s {$size}k | gzip -c > $filename
                case '*.tar.bz'
                    tar cf - $args | pv -p -s {$size}k | bzip2 -c > $filename
                case '*.tbz'
                    tar cf - $args | pv -p -s {$size}k | bzip2 -c > $filename
                case '*.zip'
                    zip $filename $args
                case '*'
                    set -l extension (echo $filename | awk -F . '{print $NF}')
                    echo "I don't know how to make a '$extension' file."
                    return
                end
            set -l shrunk (du -sk $filename | cut -f 1)
            set -l ratio ( math 100 - "$shrunk * 100.0 / $size")
            echo Reduced {$size}k to {$shrunk}k \({$ratio}%\)
        end
      '';

      gruvbox-theme-set = ''
        function gruvbox-theme-set
            set -U fish_color_param ebdbb2
            set -U fish_color_command 689d6a

            # TODO:
            set -U fish_color_normal normal
            set -U fish_pager_color_secondary_completion 
            set -U fish_pager_color_secondary_description 
            set -U fish_color_keyword 99cc99
            set -U fish_pager_color_secondary_background 
            set -U fish_color_quote ffcc66
            set -U fish_pager_color_secondary_prefix 
            set -U fish_color_redirection d3d0c8
            set -U fish_pager_color_selected_description 
            set -U fish_color_end cc99cc
            set -U fish_pager_color_background 
            set -U fish_color_error f2777a
            set -U fish_pager_color_selected_completion 
            set -U fish_color_comment ffcc66
            set -U fish_color_selection white --bold --background=brblack
            set -U fish_color_search_match white --bold --background=brblack
            set -U fish_color_history_current --bold
            set -U fish_color_operator 6699cc
            set -U fish_color_escape 66cccc
            set -U fish_color_cwd green
            set -U fish_color_cwd_root red
            set -U fish_color_option d3d0c8
            set -U fish_color_valid_path --underline=single
            set -U fish_color_autosuggestion 747369
            set -U fish_color_user brgreen
            set -U fish_color_host normal
            set -U fish_color_host_remote yellow
            set -U fish_color_history_current --bold
            set -U fish_color_status red
            set -U fish_color_cancel --reverse
            set -U fish_pager_color_prefix normal --bold --underline=single
            set -U fish_pager_color_progress brwhite --bold --background=cyan
            set -U fish_pager_color_completion normal
            set -U fish_pager_color_description B3A06D
            set -U fish_pager_color_selected_background --background=brblack
            set -U fish_pager_color_selected_prefix 
            set -U fish_pager_color_secondary_completion 
            set -U fish_pager_color_secondary_description 
            set -U fish_pager_color_secondary_background 
            set -U fish_pager_color_secondary_prefix 
            set -U fish_pager_color_selected_description 
            set -U fish_pager_color_background 
            set -U fish_pager_color_selected_completion
        end
      '';
    };
  };
}
