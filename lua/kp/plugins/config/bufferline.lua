local opts = {
  options = {
    -- stylua: ignore
    close_command = function(n) require("mini.bufremove").delete(n, false) end,
    -- stylua: ignore
    right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,

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

-- Mappings (mini.bufremove)
local function delete_buffer()
  local bd = require("mini.bufremove").delete
  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd.write()
      bd(0)
    elseif choice == 2 then -- No
      bd(0, true)
    end
  else
    bd(0, true)
  end
end

nnoremap("<leader>bd", delete_buffer, "Delete Buffer")
-- stylua: ignore
nnoremap("<leader>bD", function() require("mini.bufremove").delete(0, true) end, "Delete Buffer (Force)")
nnoremap("<leader>c", delete_buffer, "Delete Buffer (Force)")

-- Mappings (bufferline)
nnoremap("<leader>p", "<Cmd>BufferLinePick<CR>", "Pick buffer")
nnoremap("<leader>bc", "<Cmd>BufferLineCloseOthers<CR>", "Delete other buffers")
nnoremap("<leader>br", "<Cmd>BufferLineCloseRight<CR>", "Delete buffers to the right")
nnoremap("<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", "Delete buffers to the left")
nnoremap("{", "<cmd>BufferLineCyclePrev<cr>", "Prev buffer")
nnoremap("}", "<cmd>BufferLineCycleNext<cr>", "Next buffer")
