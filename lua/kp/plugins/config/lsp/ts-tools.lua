local M = {}

function M.should_setup(server_name)
  return server_name == "ts_ls"
end

function M.setup()
  require("typescript-tools").setup({
    settings = {
      tsserver_max_memory = 8192,
      tsserver_file_preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        importModuleSpecifierPreference = "relative",
        quotePreference = "auto",
        includeInlayParameterNameHints = "all",
      },
    },
    on_attach = function()
      -- Mappings
      nnoremap("<leader>lo", "<cmd>TSToolsOrganizeImports<cr>", "Organize Imports")
    end
  })
end

return M
