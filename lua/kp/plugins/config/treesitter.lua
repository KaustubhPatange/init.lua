local opts = {
  highlight = { enable = true },
  auto_install = false,
  incremental_selection = { enable = true },
  autotag = { enable = true, enable_close_on_slash = false },
  ensure_installed = { "query", "vimdoc", "lua", "javascript", "typescript", "tsx", "python" },
  context_commentstring = {
    enable = true,
    config = {
      javascript = {
        __default = "// %s",
        jsx_element = "{/* %s */}",
        jsx_fragment = "{/* %s */}",
        jsx_attribute = "// %s",
        comment = "// %s",
      },
      typescript = {
        __default = "// %s",
        __multiline = "/* %s */",
        jsx_element = "{/* %s */}",
        jsx_fragment = "{/* %s */}",
        jsx_attribute = "// %s",
      },
    },
  },
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
require("ts_context_commentstring").setup {}

local comment = require "Comment"
comment.setup {
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
}

-- Mappings (Comment)
nnoremap(
  "<leader>/",
  function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
  "Comment line"
)
vnoremap(
  "<leader>/",
  "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
  "Toggle comment line"
)

-- Mappings (Treesitter)
