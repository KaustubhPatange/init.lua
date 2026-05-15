-- Few examples on local config, @see util/local-config.lua
--
-- local rust_analyzer = require("kp.plugins.config.lsp.rust_analyzer")
-- rust_analyzer.setup({
--   settings = {
--     ["rust-analyzer"] = {
--       checkOnSave = { command = "clippy" },
--     },
--   },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

M.config = {}

function M.setup(merge_config)
  local final = merge_config and util.deep_merge(M.config, merge_config) or M.config
  vim.lsp.config("rust_analyzer", final)
  vim.lsp.enable("rust_analyzer")
end

return M
