return {
  "VonHeikemen/lsp-zero.nvim",
  lazy = false,
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "onsails/lspkind.nvim",
    "stevearc/conform.nvim",
    "mfussenegger/nvim-jdtls",
    "pmizio/typescript-tools.nvim"
  },
  config = function() require "kp.plugins.config.lsp" end,
}
