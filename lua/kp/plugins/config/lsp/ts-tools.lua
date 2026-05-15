-- Few examples on local config, @see util/local-config.lua
--
-- local ts = require("kp.plugins.config.lsp.ts-tools")
-- ts.setup({
--   settings = {
--     tsserver_file_preferences = {
--       importModuleSpecifierPreference = "non-relative",
--     },
--   },
-- })

local util = require("kp.plugins.config.lsp.util")
local M = {}

function M.should_setup(server_name)
  return server_name == "ts_ls"
end

M.config = {
  settings = {
    tsserver_max_memory = 16000, -- prev. 8192
    tsserver_file_preferences = {
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      importModuleSpecifierPreference = "relative",
      quotePreference = "auto",
      includeInlayParameterNameHints = "all",
    },
    vtsls = {
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    nnoremap("<leader>lo", "<cmd>TSToolsOrganizeImports<cr>", "Organize Imports")
  end,
}

function M.setup(merge_config)
  local final = merge_config and util.deep_merge(M.config, merge_config) or M.config
  require("typescript-tools").setup(final)
end

return M
