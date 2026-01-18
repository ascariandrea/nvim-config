return { -- Autoformat
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo", "Format" },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true, sh = true }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] or vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        lsp_format_opt = "never"
      else
        lsp_format_opt = "fallback"
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- Run Prettier first, then ESLint (both sequentially). Add common JS/TS filetypes.
      javascript = { "prettier", "eslint" },
      javascriptreact = { "prettier", "eslint" },
      typescript = { "prettier", "eslint" },
      typescriptreact = { "prettier", "eslint" },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)
    -- Register the conform format command
    vim.api.nvim_create_user_command("Format", function(opts)
      local range = nil
      if opts.range then
        local start_line = opts.line1
        local end_line_num = opts.line2
        local end_line = vim.api.nvim_buf_get_lines(0, end_line_num - 1, end_line_num, true)[1] or ""
        range = {
          start = { start_line, 0 },
          ["end"] = { end_line_num, #end_line },
        }
      end

      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
}
