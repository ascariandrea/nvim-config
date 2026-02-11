local on_attach = require("util").on_attach

local vue_plugin_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

--- Check if the project at `root` uses Vue by looking at package.json
---@param root string
---@return boolean
local function project_has_vue(root)
  local pkg_path = root .. "/package.json"
  local f = io.open(pkg_path, "r")
  if not f then
    return false
  end
  local content = f:read("*a")
  f:close()
  return content:find('"vue"') ~= nil
end

return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  on_attach = on_attach,
  before_init = function(_, config)
    local plugins = {}
    if vim.fn.isdirectory(vue_plugin_path) == 1 and project_has_vue(config.root_dir) then
      table.insert(plugins, {
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
        languages = { "vue" },
        location = vue_plugin_path,
        name = "@vue/typescript-plugin",
      })
    end
    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      vtsls = { tsserver = { globalPlugins = plugins } },
    })
  end,
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {},
        maxTsServerMemory = 8192,
      },
    },
  },
}
