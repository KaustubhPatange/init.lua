return {
  'stevearc/quicker.nvim',
  event = "FileType qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {
    keys = {
      { "<C-o>",     "" },
      { "<leader>]", ":cnewer<cr>", desc = "Next Quickfix" },
      { "<leader>[", ":colder<cr>", desc = "Previous Quickfix" },
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    }
  },
}
