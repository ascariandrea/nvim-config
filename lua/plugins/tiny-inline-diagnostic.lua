return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000,
  config = function()
    vim.diagnostic.config({ virtual_text = false })

    require("tiny-inline-diagnostic").setup({
      preset = "powerline",
      options = {
        show_source = true,
        multilines = {
          enabled = true,
          always_show = true,
        },
        show_all_diags_on_cursorline = true,
        enable_on_insert = false,
      },
    })
  end,
}
