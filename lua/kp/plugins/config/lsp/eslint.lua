-- Few examples on local config, @see util/local-config.lua
--
-- local eslint = require("kp.plugins.config.lsp.eslint")
-- eslint.setup({
--   settings = {
--     quiet = true,
--   },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

M.config = {
  cmd_env = {
    NODE_OPTIONS = "--max-old-space-size=8192"
  },
  settings = {
    codeAction = {
      showDocumentation = {
        enable = false
      }
    },
    codeActionOnSave = {
      enable = false
    },
    format = false,
    quiet = false,
  },
}

function M.setup(merge_config)
  local final = merge_config and util.deep_merge(M.config, merge_config) or M.config
  vim.lsp.config("eslint", final)
  vim.lsp.enable("eslint")
end

return M
