-- Few examples on local config, @see util/local-config.lua
--
-- local kotlin_lsp = require("kp.plugins.config.lsp.kotlin_lsp")
-- kotlin_lsp.setup({
--   settings = { ... },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

M.config = {}

function M.setup(merge_config)
  local final = merge_config and util.deep_merge(M.config, merge_config) or M.config
  vim.lsp.config("kotlin_lsp", final)
  vim.lsp.enable("kotlin_lsp")
end

return M
