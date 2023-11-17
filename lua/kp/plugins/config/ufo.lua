vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require("ufo").setup {
  provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end,
}

-- Mapping
nnoremap("zR", require("ufo").openAllFolds, "Open all folds")
nnoremap("zM", require("ufo").closeAllFolds, "Close all folds")
