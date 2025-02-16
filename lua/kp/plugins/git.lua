return {
  "sindrets/diffview.nvim",
  dependencies = {
    "tpope/vim-fugitive",
  },
  config = function() require "kp.plugins.config.git" end,
}
