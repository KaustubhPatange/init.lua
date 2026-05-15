-- Few examples on local config, @see util/local-config.lua
--
-- local gopls = require("kp.plugins.config.lsp.gopls")
-- gopls.setup({
--   settings = {
--     gopls = {
--       env = { GOFLAGS = "-tags=integration" },
--     },
--   },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

M.config = {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

function M.setup(merge_config)
  local final = merge_config and util.deep_merge(M.config, merge_config) or M.config
  vim.lsp.config("gopls", final)
  vim.lsp.enable("gopls")
end

return M
