
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  desc = "Highlight selection on yank",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Open help files in a vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  command = "wincmd L",
})

-- Disable auto commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("No auto comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Delete quickfix entry under cursor with dd
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", function()
      local items = vim.fn.getqflist()
      local line = vim.fn.line(".")
      table.remove(items, line)
      vim.fn.setqflist(items, "r")
      if #items > 0 then
        vim.cmd(string.format("cc %d", math.min(line, #items)))
      end
    end, { buffer = true, silent = true })
  end,
})

-- Disable copilot suggestion when BlinkCmp menu is open
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    require("copilot.suggestion").dismiss()
    vim.b.copilot_suggestion_hidden = true
  end,
})

-- Re-enable copilot suggestion when BlinkCmp menu is closed
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})


vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
            },
        })
    end
})
