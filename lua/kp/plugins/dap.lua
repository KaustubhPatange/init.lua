return {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "folke/neodev.nvim",
  },
  lazy = false,
  config = function() require "kp.plugins.config.dap" end,
}
