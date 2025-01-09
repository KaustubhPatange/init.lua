return {
  "VonHeikemen/lsp-zero.nvim",
  lazy = false,
  branch = "v3.x",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "onsails/lspkind.nvim",
    "stevearc/conform.nvim",
    "mfussenegger/nvim-jdtls",
  },
  config = function() require "kp.plugins.config.lsp" end,
}
