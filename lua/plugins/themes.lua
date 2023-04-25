return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.nightfox", enabled = false },
  { import = "astrocommunity.colorscheme.kanagawa", enabled = true },
  {
    import = "astrocommunity.colorscheme.rose-pine",
    config = function()
      vim.g.rose_pine_variant = "dawn"
      vim.g.rose_pine_disable_background = true
    end
  },
  { import = "astrocommunity.colorscheme.catppuccin" },
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
  { "Mofiqul/vscode.nvim" },
  {
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup({
        theme_style = "dark_default",
        sidebars = { "qf", "vista_kind", "terminal", "packer" },
        dark_sidebar = true,
        dark_float = true,
      })
    end
  },
  { "AlexvZyl/nordic.nvim" },
  {
    -- further customize the options set by the community
    "catppuccin",
    opts = {
      integrations = {
        sandwich = false,
        noice = true,
        mini = true,
        leap = true,
        markdown = true,
        neotest = true,
        cmp = true,
        overseer = true,
        lsp_trouble = true,
        ts_rainbow2 = true,
      },
    },
  },
}
