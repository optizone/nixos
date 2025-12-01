{ pkgs, ... }:
{
  # NOTE: see options for nvf at https://notashelf.github.io/nvf/options.html

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ./languages/default.nix

    ./keymaps.nix

    ./plugins/lualine.nix
    ./plugins/neo-tree.nix
    # ./plugins/nvim-tree.nix

    ./custom-plugins/layout-mappers.nix

    ./themes/gruvbox.nix
  ];

  home.packages = [
    pkgs.nixd
  ];

  programs.nvf = {
    enable = true;

    settings.config.vim = {
      viAlias = true;
      vimAlias = true;
      searchCase = "smart";

      # ------------------------------------------------------------

      options = {
        wrap = false;
        conceallevel = 0;
        foldlevel = 99;
      };

      lsp = {
        enable = true;

        formatOnSave = true;
        lspkind.enable = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        otter-nvim.enable = true;
        nvim-docs-view.enable = true;
        inlayHints.enable = true;
      };

      debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };

      autocomplete.blink-cmp.enable = true;

      # ------------------------------------------------------------

      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = false;
        cinnamon-nvim.enable = false;
        fidget-nvim.enable = false;

        rainbow-delimiters.enable = false;

        highlight-undo.enable = true;
        indent-blankline.enable = true;
      };

      # ------------------------------------------------------------

      autopairs.nvim-autopairs.enable = true;

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };

      snippets.luasnip.enable = true;

      diagnostics = {
        enable = true;
        nvim-lint.enable = true;
        config.virtual_lines = false;
        config.virtual_text = true;
      };

      tabline = {
        nvimBufferline = {
          enable = true;
          mappings = {
            closeCurrent = "<leader>bd";
          };
        };
      };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
        hardtime-nvim.enable = true;
      };

      git.enable = true;

      minimap = {
        codewindow = {
          enable = true;
          mappings = {
            open = "<leader>mo";
            toggle = "<leader>mm";
            toggleFocus = "<leader>mf";
          };
        };
      };

      notify = {
        nvim-notify = {
          enable = true;
          # FIXME: hack for transparent gruvbox theme
          setupOpts.background_colour = "#282828";
        };
      };

      projects = {
        project-nvim.enable = true;
      };

      utility = {
        outline.aerial-nvim = {
          enable = true;
          mappings.toggle = "<leader>cs";
        };

        icon-picker.enable = true;
        surround.enable = true;

        yazi-nvim = {
          enable = true;
          mappings = {
            openYazi = "<leader>-";
            openYaziDir = "<leader>cw";
            yaziToggle = "<c-up>";
          };
        };

        snacks-nvim = {
          enable = true;
          setupOpts = {
            picker.enabled = true;
          };
        };
      };

      formatter = {
        conform-nvim.enable = true;
      };

      notes = {
        todo-comments = {
          enable = true;
          mappings = {
            quickFix = "<leader>tdq";
            telescope = "<leader>tds";
            trouble = "<leader>tdt";
          };
        };
      };

      # TODO: toggle
      terminal = {
        toggleterm = {
          enable = true;
          mappings.open = "<c-t>";
          lazygit.enable = true;
          lazygit.mappings.open = "<leader>gg";
          setupOpts = {
            terminal_mappings = true;
            insert_mappings = true;
            shell = "fish";
          };
        };
      };

      navigation = {
        harpoon = {
          enable = true;
        };
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        illuminate.enable = true;
        breadcrumbs = {
          enable = true;
          navbuddy.enable = true;
        };
        smartcolumn = {
          enable = true;
          setupOpts.custom_column = {
            nix = "110";
            ruby = "120";
            java = "130";
            go = [
              "90"
              "130"
            ];
            rust = "120";
          };
        };
      };

      session = {
        nvim-session-manager = {
          enable = true;
          mappings = {
            deleteSession = "<leader>sd";
            loadLastSession = "<leader>slt";
            loadSession = "<leader>sl";
            saveCurrentSession = "<leader>sc";
          };
        };
      };

      comments = {
        comment-nvim = {
          enable = true;
          mappings = {
            toggleCurrentBlock = "gbc";
            toggleCurrentLine = "gcc";
            toggleOpLeaderLine = "gc";
            toggleSelectedBlock = "gb";
            toggleSelectedLine = "gc";
          };
        };
      };
    };
  };
}
