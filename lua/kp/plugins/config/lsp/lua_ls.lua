-- Few examples on local config, @see util/local-config.lua
--
-- local lua_ls = require("kp.plugins.config.lsp.lua_ls")
-- lua_ls.setup({
--   settings = {
--     Lua = {
--       diagnostics = { globals = { "vim" } },
--     },
--   },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

M.config = {}

function M.setup(merge_config)
  local lsp_zero = require("lsp-zero")
  local base = lsp_zero.nvim_lua_ls()
  local patched = merge_config and util.deep_merge(base, merge_config) or base
  vim.lsp.config("lua_ls", patched)
  vim.lsp.enable("lua_ls")
end

return M
