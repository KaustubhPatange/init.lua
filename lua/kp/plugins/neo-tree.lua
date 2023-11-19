return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    init = function() vim.g.neo_tree_remove_legacy_commands = true end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require("kp.plugins.config.neo-tree")
    end
}
