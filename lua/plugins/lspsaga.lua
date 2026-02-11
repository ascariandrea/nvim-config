return {
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        ui = {
          title = true,
          border = "rounded",
          winblend = 0,
          expand = "",
          collapse = "",
          code_action = "💡",
          diagnostic = "🐛",
          incoming = " ",
          outgoing = " ",
          kind = {},
        },
        outline = {
          win_position = "right",
          win_with = "",
          win_width = 30,
          preview_width = 0.4,
          show_detail = true,
          auto_preview = true,
          auto_refresh = true,
          auto_close = true,
          keys = {
            toggle_or_jump = "o",
            quit = "q",
          },
        },
        hover = {
          max_width = 0.9,
          max_height = 0.8,
          open_link = "gx",
        },
        definition = {
          width = 0.6,
          height = 0.5,
          keys = {
            edit = "o",
            vsplit = "v",
            split = "i",
            tabe = "t",
            quit = "q",
          },
        },
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = false,
          keys = {
            quit = "q",
            exec = "<CR>",
          },
        },
        rename = {
          in_select = true,
          auto_save = false,
          project_max_width = 0.5,
          project_max_height = 0.5,
          keys = {
            quit = "<C-k>",
            exec = "<CR>",
            select = "x",
          },
        },
        diagnostic = {
          show_code_action = true,
          jump_num_shortcut = true,
          max_width = 0.8,
          max_height = 0.6,
          text_hl_follow = true,
          border_follow = true,
          extend_relatedInformation = false,
          keys = {
            exec_action = "o",
            quit = "q",
            toggle_or_jump = "<CR>",
            quit_in_show = { "q", "<ESC>" },
          },
        },
      })

      local map = require("util").map
      -- LSP Saga keymaps
      map("<leader>ll", "<cmd>Lspsaga hover_doc<CR>", "Lspsaga Hover")
      map("<leader>ld", "<cmd>Lspsaga peek_definition<CR>", "Lspsaga Peek Definition")
      map("<leader>lD", "<cmd>Lspsaga goto_definition<CR>", "Lspsaga Goto Definition")
      map("<leader>lt", "<cmd>Lspsaga peek_type_definition<CR>", "Lspsaga Peek Type Def")
      map("<leader>lT", "<cmd>Lspsaga goto_type_definition<CR>", "Lspsaga Goto Type Def")
      map("<leader>lr", "<cmd>Lspsaga lsp_rename<CR>", "Lspsaga Rename")
      map("<leader>la", "<cmd>Lspsaga code_action<CR>", "Lspsaga Code Action")
      map("<leader>lo", "<cmd>Lspsaga outline<CR>", "Lspsaga Outline")
      map("[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Jump to prev diagnostic")
      map("]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Jump to next diagnostic")
      map("<leader>ls", "<cmd>Lspsaga show_buf_diagnostics<CR>", "Lspsaga Show Diagnostics")
      map("<leader>lw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", "Lspsaga Workspace Diagnostics")
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },
}
