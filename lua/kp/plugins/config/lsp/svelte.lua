-- Few examples on local config, @see util/local-config.lua
--
-- local svelte = require("kp.plugins.config.lsp.svelte")
-- svelte.setup({
--   settings = { ... },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

M.config = {}

function M.setup(merge_config)
  local final = merge_config and util.deep_merge(M.config, merge_config) or M.config
  vim.lsp.config("svelte", final)
  vim.lsp.enable("svelte")
end

return M
