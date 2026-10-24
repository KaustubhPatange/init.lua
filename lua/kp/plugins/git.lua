return {
  "dlyongemallo/diffview-plus.nvim",
  dependencies = {
    "tpope/vim-fugitive",
  },
  config = function() require "kp.plugins.config.git" end,
}
