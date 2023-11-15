return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "numToStr/Comment.nvim",
      "nvim-treesitter/playground",
    },
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = ":TSUpdate",
    lazy = false,
    config = function() require "kp.plugins.config.treesitter" end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    cmd = { "TSContextDisable", "TSContextEnable", "TSContextToggle" },
    config = function() require "kp.plugins.config.treesitter-context" end,
  },
}
