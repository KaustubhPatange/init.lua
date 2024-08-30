vim.g.mapleader = " "
-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vm.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Hide command line
vim.o.cmdheight = 0
-- Set maxium height of popup menu
vim.o.pumheight = 10

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv "HOME" .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append "@-@"

vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.infercase = true

vim.o.updatetime = 250

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  command =
  "lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=100} ",
})

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])

-- Indent/Unindent line
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("v", "<Tab>", ">gv")

-- Search settings
vim.opt.hlsearch = true
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function() vim.api.nvim_set_hl(0, "Search", { bg = "LightGreen" }) end,
})
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
vim.keymap.set({ "n" }, "<leader>bq", "<cmd>cclose<cr>", { desc = "Close quickfix" })

-- Disable page up & page down keys
vim.keymap.set({ "i", "n", "v" }, "<PageUp>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<PageDown>", "<nop>")
