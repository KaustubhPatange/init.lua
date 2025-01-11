local M = {}

function M.should_setup(server_name)
  return server_name == "tsserver"
end

function M.setup()
  require("typescript-tools").setup({
    on_attach = function()
      -- Mappings
      nnoremap("<leader>lo", "<cmd>TSToolsOrganizeImports<cr>", "Organize Imports")
    end
  })
end

return M
