_: {
  config.vim.keymaps = [
    # TODO: else vim.lsp.buf.codeAction()
    {
      key = "<leader>ca";
      mode = [
        "n"
        "v"
      ];
      action = "<Cmd>RustLsp codeAction<CR>";
      silent = true;
      desc = "Code Action for Rust LSP";
    }
    {
      key = "<leader>cd";
      mode = [
        "n"
        "v"
      ];
      action = "<Cmd>RustLsp renderDiagnostic current<CR>";
      silent = true;
      desc = "Render diagnostic";
    }
    {
      key = "<leader>cr";
      mode = [ "n" ];
      action = "vim.lsp.buf.rename";
      lua = true;
      desc = "Rename";
    }

    # {
    #   key = "K";
    #   mode = [ "n" ];
    #   action = "<Cmd>RustLsp hover actions<CR>";
    #   silent = true;
    #   desc = "rustaceanvim hover actions";
    # }
    {
      key = "<esc>";
      mode = [ "n" ];
      action = "<Cmd>noh<CR>";
      silent = true;
      desc = "Disable search higlights";
    }
    # TODO: toggle
    {
      key = "<c-t>";
      mode = [ "t" ];
      action = "<c-\\><c-n>:CFloatTerm<CR>";
      noremap = true;
      silent = true;
      desc = "Quit toggleterm";
    }
    {
      key = "<c-s>";
      action = "<esc><Cmd>w<CR>";
      mode = [
        "n"
        "i"
      ];
      noremap = true;
      silent = true;
      desc = "Save file";
    }
    {
      key = "<leader>E";
      mode = [ "n" ];
      action = "<Cmd>Neotree toggle<CR>";
      silent = true;
      desc = "Toggle neotree";
    }
    {
      key = "<leader>e";
      mode = [ "n" ];
      action = "<Cmd>Neotree focus<CR>";
      silent = true;
      desc = "Toggle neotree";
    }
    {
      key = "<leader>qq";
      mode = [ "n" ];
      action = "<Cmd>qa<CR>";
      silent = true;
      desc = "Quit All";
    }

    # -- Goto diagnostics
    {
      key = "]e";
      mode = [ "n" ];
      action = "function() vim.diagnostic.goto_next({severity = \"ERROR\"}) end";
      desc = "Goto next error";
      lua = true;
    }
    {
      key = "[e";
      mode = [ "n" ];
      action = "function() vim.diagnostic.goto_prev({severity = \"ERROR\"}) end";
      desc = "Goto previous error";
      lua = true;
    }
    {
      key = "]w";
      mode = [ "n" ];
      action = "function() vim.diagnostic.goto_next({severity = \"WARN\"}) end";
      desc = "Goto next warning";
      lua = true;
    }
    {
      key = "[w";
      mode = [ "n" ];
      action = "function() vim.diagnostic.goto_prev({severity = \"WARN\"}) end";
      desc = "Goto previous warning";
      lua = true;
    }
    {
      key = "]d";
      mode = [ "n" ];
      action = "function() vim.diagnostic.goto_next({severity = nil}) end";
      desc = "Goto next diagnostic";
      lua = true;
    }
    {
      key = "[d";
      mode = [ "n" ];
      action = "function() vim.diagnostic.goto_prev({severity = nil}) end";
      desc = "Goto previous diagnostics";
      lua = true;
    }
    {
      key = "<leader>cd";
      mode = [ "n" ];
      action = "vim.diagnostic.open_float";
      desc = "Line diagnostics";
      lua = true;
    }

    # -- Top Pickers
    {
      key = "<leader>ff";
      mode = [ "n" ];
      action = "function() Snacks.picker.smart() end";
      desc = "Smart Find Files";
      lua = true;
    }
    {
      key = "<space><space>";
      mode = [ "n" ];
      action = "function() Snacks.picker.grep() end";
      desc = "Grep";
      lua = true;
    }
    {
      key = "<leader>:";
      mode = [ "n" ];
      action = "function() Snacks.picker.command_history() end";
      desc = "Command History";
      lua = true;
    }
    {
      key = "<leader>,";
      mode = [ "n" ];
      action = "function() Snacks.picker.buffers() end";
      desc = "Buffers";
      lua = true;
    }
    {
      key = "<leader>n";
      mode = [ "n" ];
      action = "function() Snacks.picker.notifications() end";
      desc = "Notification History";
      lua = true;
    }

    # -- LSP
    {
      key = "gd";
      mode = [ "n" ];
      action = "function() Snacks.picker.lsp_definitions() end";
      desc = "Goto Definition";
      lua = true;
    }
    {
      key = "gD";
      mode = [ "n" ];
      action = "function() Snacks.picker.lsp_declarations() end";
      desc = "Goto Declaration";
      lua = true;
    }
    {
      key = "gr";
      mode = [ "n" ];
      action = "function() Snacks.picker.lsp_references() end";
      desc = "References";
      nowait = true;
      lua = true;
    }
    {
      key = "gi";
      mode = [ "n" ];
      action = "function() Snacks.picker.lsp_implementations() end";
      desc = "Goto Implementation";
      lua = true;
    }
    {
      key = "gy";
      mode = [ "n" ];
      action = "function() Snacks.picker.lsp_type_definitions() end";
      desc = "Goto T[y]pe Definition";
      lua = true;
    }
    {
      key = "<leader>ss";
      mode = [ "n" ];
      action = "function() Snacks.picker.lsp_symbols() end";
      desc = "LSP Symbols";
      lua = true;
    }
    {
      key = "<leader>sS";
      mode = [ "n" ];
      action = "function() Snacks.picker.lsp_workspace_symbols() end";
      desc = "LSP Workspace Symbols";
      lua = true;
    }

    # -- Other
    {
      key = "<leader>bd";
      mode = [ "n" ];
      action = "function() Snacks.bufdelete() end";
      desc = "Delete buffer";
      lua = true;
    }
  ];
}
