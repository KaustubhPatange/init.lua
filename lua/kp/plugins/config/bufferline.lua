local opts = {
  options = {
    -- stylua: ignore
    close_command = function(n) require("mini.bufremove").delete(n, false) end,
    -- stylua: ignore
    right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    diagnostics_indicator = function(_, _, diag)
      local icons = require("lazyvim.config").icons.diagnostics
      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
}

require("bufferline").setup(opts)

-- Fix bufferline when restoring a session
vim.api.nvim_create_autocmd("BufAdd", {
  callback = function()
    vim.schedule(function()
      pcall(nvim_bufferline)
    end)
  end,
})

-- Mappings (mini.bufremove)
nnoremap("<leader>bd", function()
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
        bd(0)
      end
  end,
  "Delete Buffer"
)
-- stylua: ignore
nnoremap("<leader>bD", function() require("mini.bufremove").delete(0, true) end, "Delete Buffer (Force)")

-- Mappings (bufferline)
nnoremap("<leader>bp", "<Cmd>BufferLineTogglePin<CR>", "Toggle pin")
nnoremap("<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", "Delete non-pinned buffers")
nnoremap("<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", "Delete other buffers")
nnoremap("<leader>br", "<Cmd>BufferLineCloseRight<CR>", "Delete buffers to the right")
nnoremap("<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", "Delete buffers to the left")
nnoremap("{", "<cmd>BufferLineCyclePrev<cr>", "Prev buffer")
nnoremap("}", "<cmd>BufferLineCycleNext<cr>", "Next buffer")
