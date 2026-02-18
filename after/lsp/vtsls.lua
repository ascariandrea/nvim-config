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

--- Check if `dir` is a monorepo workspace root
---@param dir string
---@return boolean
local function is_workspace_root(dir)
  return vim.fn.filereadable(dir .. "/pnpm-workspace.yaml") == 1
    or vim.fn.filereadable(dir .. "/lerna.json") == 1
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
  -- Scope root_dir to the nearest package to avoid tsserver loading the entire monorepo
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local util = require("lspconfig.util")
    local tsconfig_root = util.root_pattern("tsconfig.json")(fname)
    if tsconfig_root and is_workspace_root(tsconfig_root) then
      -- Monorepo root found — prefer the nearest package.json directory instead
      local pkg_root = util.root_pattern("package.json")(vim.fn.fnamemodify(fname, ":h") .. "/.")
      if pkg_root and pkg_root ~= tsconfig_root then
        on_dir(pkg_root)
        return
      end
    end
    on_dir(tsconfig_root)
  end,
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
    -- maxTsServerMemory must be under typescript.tsserver, not vtsls.tsserver
    typescript = {
      tsserver = {
        maxTsServerMemory = 8192,
      },
      workspaceSymbols = {
        -- Only search symbols in the current package, not the entire monorepo
        scope = "currentProject",
      },
    },
    vtsls = {
      tsserver = {
        globalPlugins = {},
      },
    },
  },
}
