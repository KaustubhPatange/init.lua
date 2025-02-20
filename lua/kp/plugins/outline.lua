return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>lS", "<cmd>Outline<CR>", desc = "Symbols outline" },
  },
  opts = {
    -- Your setup opts here
    keymaps = {
      close = { 'q' }
    }
  },
}
