return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("kp.plugins.config.bufferline")
    end,
  },
  {
    "famiu/bufdelete.nvim",
    lazy = false,
  }
}
