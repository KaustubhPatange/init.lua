local function bdelete(bufnr, force)
  force = force or false
  local bd = require("bufdelete")
  bd.bufdelete(bufnr, force)
end

local function delete_buffer()
  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd.write()
      bdelete(0)
    elseif choice == 2 then -- No
      bdelete(0, true)
    end
  else
    bdelete(0, true)
  end
end

local opts = {
  options = {
    -- diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    diagnostics_indicator = function(_, _, diag)
      local icons = require "util.icons"
      local ret = (diag.error and icons.DiagnosticError .. diag.error .. " " or "")
          .. (diag.warning and icons.DiagnosticWarn .. diag.warning or "")
      return vim.trim(ret)
    end,
    custom_filter = function(buf_number, _)
      -- Filter out Quickfix list buffer
      if vim.bo[buf_number].filetype ~= "qf" then return true end
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
}

require("bufferline").setup(opts)

-- Save current view settings on a per-buffer basis
-- When switching buffers, preserve window view
-- Restore current view settings
-- Ref: https://github.com/akinsho/bufferline.nvim/issues/413
local SavedBufView = {}

function AutoSaveWinView()
  local buf = vim.api.nvim_get_current_buf()
  SavedBufView[buf] = vim.fn.winsaveview()
end

function AutoRestoreWinView()
  local buf = vim.api.nvim_get_current_buf()
  if SavedBufView[buf] then
    local view = vim.fn.winsaveview()
    local atStartOfFile = view.lnum == 1 and view.col == 0
    if atStartOfFile and not vim.wo.diff then
      vim.fn.winrestview(SavedBufView[buf])
    end
    SavedBufView[buf] = nil
  end
end

function RemoveBufferFromSavedView()
  local buf = vim.api.nvim_get_current_buf()
  SavedBufView[buf] = nil
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy", -- Adjust based on your lazy loading configuration
  callback = function()
    vim.api.nvim_exec([[
          augroup AutoWinView
            autocmd!
            autocmd BufLeave * lua AutoSaveWinView()
            autocmd BufEnter * lua AutoRestoreWinView()
            autocmd BDeletePost * lua RemoveBufferFromSavedView()
          augroup END
        ]], false)
  end,
})

local function print_buffer_name()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype == "" then
    vim.notify(vim.api.nvim_buf_get_name(bufnr), vim.log.levels.WARN)
  end
end

-- Mappings
nnoremap("<leader>bd", delete_buffer, "Delete Buffer")
nnoremap("<leader>bD", "<cmd>bdelete<CR>", "Delete Buffer (Force)")
nnoremap("<leader>c", delete_buffer, "Delete Buffer")
nnoremap("<leader>p", "<Cmd>BufferLinePick<CR>", "Pick buffer")
nnoremap("<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", "Delete other buffers")
nnoremap("<leader>br", "<Cmd>BufferLineCloseRight<CR>", "Delete buffers to the right")
nnoremap("<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", "Delete buffers to the left")
nnoremap("<leader>bp", "<Cmd>BufferLineTogglePin<CR>", "Print buffer name")
nnoremap("<leader>bn", print_buffer_name, "Print buffer name")
nnoremap("<leader>by", function()
  if vim.bo.buftype == "" then
    require("util.file-copy").open_file_copy_selector()
  end
end, "Copy Selector")
nnoremap("{", "<cmd>BufferLineCyclePrev<cr>", "Prev buffer")
nnoremap("}", "<cmd>BufferLineCycleNext<cr>", "Next buffer")
