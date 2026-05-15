-- Few examples on local config, @see util/local-config.lua
--
-- local biome = require("kp.plugins.config.lsp.biome")
-- biome.setup({
--   settings = {
--     -- biome-specific overrides
--   },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

M.config = {
  root_dir = require("lspconfig.util").root_pattern("biome.json", "biome.jsonc"),
}

function M.setup(merge_config)
  local final = merge_config and util.deep_merge(M.config, merge_config) or M.config
  vim.lsp.config("biome", final)
  vim.lsp.enable("biome")
end

return M
