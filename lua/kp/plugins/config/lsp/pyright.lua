-- Few examples on local config, @see util/local-config.lua
--
-- local pyright = require("kp.plugins.config.lsp.pyright")
-- pyright.setup({
--   settings = {
--     python = {
--       analysis = {
--         diagnosticMode = "workspace",
--       },
--     },
--   },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

M.config = {
  settings = {
    python = {
      analysis = {
        -- diagnosticMode = "workspace",
      },
    },
  },
}

function M.setup(merge_config)
  local final = merge_config and util.deep_merge(M.config, merge_config) or M.config
  vim.lsp.config("pyright", final)
  vim.lsp.enable("pyright")
end

return M
