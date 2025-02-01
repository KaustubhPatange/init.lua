require('ts-comments').setup()

local opts = {
  highlight = { enable = true },
  auto_install = false,
  incremental_selection = { enable = true },
  autotag = { enable = true, enable_close_on_slash = false },
  ensure_installed = { "query", "vimdoc", "lua", "javascript", "typescript", "tsx", "python" },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  refactor = {
    navigation = {
      enable = true,
      -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
      keymaps = {
        goto_definition = false,
        list_definitions = false,
        list_definitions_toc = false,
        goto_next_usage = "]]",
        goto_previous_usage = "[[",
      },
    },
  },
}
require("nvim-treesitter.configs").setup(opts)

-- -- Mappings
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("v", "<leader>/", "gc", { remap = true, silent = true, desc = "Toggle comment line" })
