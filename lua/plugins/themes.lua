return {
  { import = "astrocommunity.colorscheme.nightfox", enabled = false },
  { import = "astrocommunity.colorscheme.kanagawa", enabled = true },
  {
    import = "astrocommunity.colorscheme.rose-pine",
    config = function()
      vim.g.rose_pine_variant = "dawn"
      vim.g.rose_pine_disable_background = true
    end
  },
  { "rmehri01/onenord.nvim" },
  { "Shatur/neovim-ayu" },
  {
    "marko-cerovac/material.nvim",
    config = function()
      vim.g.material_style = "deep ocean"
    end
  },
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup({
        style = "warmer"
      })
    end
  },
}
