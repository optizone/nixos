{ ... }:
{
  config.vim.filetree.neo-tree = {
    enable = true;

    setupOpts = {
      window = {
        position = "right";
        default_component_configs = {
          indent = {
            with_expanders = true;
            expander_collapsed = "";
            expander_expanded = "";
            expander_highlight = "NeoTreeExpander";
          };
          git_status = {
            symbols = {
              unstaged = "󰄱";
              staged = "󰱒";
            };
          };
        };

        name = {
          use_git_status_colors = false;
        };

        mappings = {
          "l" = "open";
          "h" = "close_node";
          "p" = "toggle_preview";
          "<space>" = "none";
        };
      };

      enable_diagnostics = true;
      git_status_async = true;

      filesystem = {
        follow_current_file.enabled = false;
        use_libuv_file_watcher = true;
      };
    };
  };

}
