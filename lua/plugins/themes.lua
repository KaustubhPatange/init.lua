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
