opts = {
  highlight = { enable = true },
  auto_install = false,
  incremental_selection = { enable = true },
  autotag = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
  ensure_installed = {"lua", "javascript", "typescript", "python"},
}

require('Comment').setup()
require("nvim-treesitter.configs").setup(opts)
    
-- Mappings (Comment)
nnoremap("<leader>/", function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end, "Comment line")
vnoremap("<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", "Toggle comment line")

-- Mappings (Treesitter)

