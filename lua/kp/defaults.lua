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

vim.opt.scrolloff = 8
vim.opt.isfname:append "@-@"

vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.infercase = true

vim.o.updatetime = 250

vim.o.sessionoptions = "blank,buffers"
vim.o.jumpoptions = "view"

vim.opt.clipboard = ""


-- Load default internal vim plugins
vim.cmd("packadd cfilter")

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

-- Move between windows
vim.keymap.set({ "n" }, "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set({ "n" }, "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set({ "n" }, "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set({ "n" }, "<C-l>", "<C-w>l", { silent = true })

-- Highlight current cursor line command
local cursor_highlight = function()
  local timer = vim.loop.new_timer()

  vim.cmd('highlight CursorHighlight cterm=bold ctermbg=yellow ctermfg=black guibg=yellow guifg=black')

  local diagnostics_enabled = vim.diagnostic.is_disabled() == false
  if diagnostics_enabled then
    vim.diagnostic.disable(0)
  end

  vim.wo.cursorline = true
  vim.wo.cursorcolumn = true
  vim.wo.winhighlight = "CursorLine:CursorHighlight,CursorColumn:CursorHighlight"

  local cnt, blink_times = 0, 8

  timer:start(0, 100, vim.schedule_wrap(function()
    vim.wo.cursorline = not vim.wo.cursorline
    vim.wo.cursorcolumn = not vim.wo.cursorcolumn

    cnt = cnt + 1
    if cnt == blink_times then
      timer:stop()
      timer:close()

      if diagnostics_enabled then
        vim.diagnostic.enable(0)
      end

      vim.wo.winhighlight = ""
      vim.wo.cursorline = false
      vim.wo.cursorcolumn = false
    end
  end))
end

vim.api.nvim_create_user_command('CursorPosition', cursor_highlight, {})
vim.api.nvim_create_user_command('CP', cursor_highlight, {})

-- Command to create file in an not exist dir
vim.api.nvim_create_user_command("WForce", function()
  local file_dir = vim.fn.expand("%:p:h")
  if vim.fn.isdirectory(file_dir) == 0 then
    vim.fn.mkdir(file_dir, "p")
  end
  vim.cmd("write")
end, { desc = "Force save by creating missing directories" })
