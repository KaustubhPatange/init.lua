return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = vim.fn.executable "make" == 1,
      build = "make",
    },
    { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    "aaronhallaert/advanced-git-search.nvim",
  },
  config = function() require "kp.plugins.config.telescope" end,
}
