return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "WhoIsSethDaniel/lualine-lsp-progress.nvim" },
  config = function() require "kp.plugins.config.lualine" end,
}
