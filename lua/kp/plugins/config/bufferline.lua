local bd = require('bufdelete')
local function bdelete(bufnr, force)
  force = force or false
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

local function close_others_except_splits_and_current()
  -- Get all file buffers from all windows
  local function get_buffers_in_splits()
    local buffers_in_splits = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) ~= '' then
        buffers_in_splits[buf] = true
      end
    end
    return buffers_in_splits
  end

  -- Get all buffers referenced in quickfix list
  local function get_buffers_in_quickfix()
    local qf_bufs = {}
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then -- if quickfix window is open
      for _, item in ipairs(vim.fn.getqflist()) do
        if item.bufnr and vim.api.nvim_buf_is_valid(item.bufnr) then
          qf_bufs[item.bufnr] = true
        end
      end
    end
    return qf_bufs
  end

  local current_buf = vim.api.nvim_get_current_buf()
  local buffers_in_splits = get_buffers_in_splits()
  local quickfix_buffers = get_buffers_in_quickfix()
  local lsp_util = require('kp.plugins.config.lsp.util')

  local protected_buffers = {}
  protected_buffers[current_buf] = true
  for buf, _ in pairs(buffers_in_splits) do
    protected_buffers[buf] = true
  end

  -- Actual buffer deleting logic
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buftype == '' then
      if not protected_buffers[bufnr] and vim.api.nvim_buf_is_valid(bufnr) then
        lsp_util.detach_clients_on_buffer(bufnr)

        if quickfix_buffers[bufnr] then
          bd.bufdelete(bufnr, true)
        else
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end
    end
  end
end

-- Filter buffer for bufdelete.nvim to ignore quickfix buftype.
-- Ref: https://github.com/famiu/bufdelete.nvim/blob/master/lua/bufdelete/init.lua#L95
vim.g.bufdelete_buf_filter = function()
  return vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype ~= 'quickfix'
  end, vim.api.nvim_list_bufs())
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

local augroup = vim.api.nvim_create_augroup("AutoWinView", { clear = true })

vim.api.nvim_create_autocmd("BufLeave", {
  group = augroup,
  callback = AutoSaveWinView,
  desc = "Save window view when leaving buffer"
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = AutoRestoreWinView,
  desc = "Restore window view when entering buffer"
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = augroup,
  callback = RemoveBufferFromSavedView,
  desc = "Remove buffer from saved views on delete"
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
nnoremap("<leader>bc", close_others_except_splits_and_current, "Delete other buffers")
nnoremap("<leader>br", "<Cmd>BufferLineCloseRight<CR>", "Delete buffers to the right")
nnoremap("<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", "Delete buffers to the left")
nnoremap("<leader>bp", "<Cmd>BufferLineTogglePin<CR>", "Pin buffer name")
nnoremap("<leader>bn", print_buffer_name, "Print buffer name")
nnoremap("<leader>by", function()
  if vim.bo.buftype == "" then
    require("util.file-copy").open_file_copy_selector()
  end
end, "Copy Selector")
nnoremap("{", "<cmd>BufferLineCyclePrev<cr>", "Prev buffer")
nnoremap("}", "<cmd>BufferLineCycleNext<cr>", "Next buffer")
