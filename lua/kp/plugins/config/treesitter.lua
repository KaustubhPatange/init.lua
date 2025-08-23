require('ts-comments').setup()

local opts = {
  highlight = { enable = true },
  auto_install = false,
  incremental_selection = { enable = true },
  autotag = { enable = true, enable_close_on_slash = false },
  ensure_installed = { "query", "vimdoc", "lua", "javascript", "typescript", "tsx", "python", "jsonc" },
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

require("treesitter-context").setup {
  enable = true,           -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 2,           -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,   -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 1, -- Maximum number of lines to show for a single context
  trim_scope = "outer",    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = "topline",        -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

-- -- Mappings
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("v", "<leader>/", "gc", { remap = true, silent = true, desc = "Toggle comment line" })
