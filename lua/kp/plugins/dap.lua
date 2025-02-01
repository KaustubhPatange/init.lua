return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "jay-babu/mason-nvim-dap.nvim",
    "williamboman/mason.nvim",
    "rcarriga/nvim-dap-ui",
    "folke/neodev.nvim",
    "nvim-neotest/nvim-nio"
  },
  lazy = false,
  config = function() require "kp.plugins.config.dap" end,
}
