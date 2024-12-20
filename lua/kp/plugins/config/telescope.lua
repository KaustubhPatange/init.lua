local telescope = require "telescope"
local actions = require "telescope.actions"
local icons = require "util.icons"
local lga_actions = require "telescope-live-grep-args.actions"

telescope.setup {
  defaults = {
    prompt_prefix = string.format("%s ", icons.Search),
    selection_caret = string.format("%s ", icons.Selected),
    path_display = { "truncate" },
    sorting_strategy = "ascending",
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "-uu", -- **This is the added flag**
    },
    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        preview_cutoff = 120,
        width = 0.87,
        height = 0.80,
      },
      vertical = {
        mirror = false,
        width = 0.80,
        height = 0.87,
        preview_height = 0.55,
      },
    },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = { ["q"] = actions.close },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = {         -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
            -- freeze the current list and start a fuzzy search in the frozen list
            ["<C-space>"] = actions.to_fuzzy_refine,
          },
        },
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      },
    },
    -- open files in the first window that is an actual file.
    -- use the current window if no other window is available.
    get_selection_window = function()
      local wins = vim.api.nvim_list_wins()
      table.insert(wins, 1, vim.api.nvim_get_current_win())
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "" then
          return win
        end
      end
      return 0
    end,
  },
}
telescope.load_extension "fzf"
telescope.load_extension "live_grep_args"

-- Mappings
nnoremap("<leader>f<CR>", function() require("telescope.builtin").resume() end, "Resume previous search")
nnoremap("<leader>f'", function() require("telescope.builtin").marks() end, "Find marks")
nnoremap("<leader>fb", function() require("telescope.builtin").buffers() end, "Find buffers")
nnoremap("<leader>fq", function() require("telescope.builtin").quickfixhistory() end, "Find quickfix")
nnoremap("<leader>fC", function() require("telescope.builtin").commands() end, "Find commands")
nnoremap("<leader>ff", function() require("telescope.builtin").find_files() end, "Find files")
nnoremap(
  "<leader>fF",
  function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
  "Find all files"
)
nnoremap("<leader>fh", function() require("telescope.builtin").help_tags() end, "Find help")
nnoremap("<leader>fk", function() require("telescope.builtin").keymaps() end, "Find keymaps")
nnoremap("<leader>fm", function() require("telescope.builtin").man_pages() end, "Find man")
nnoremap("<leader>fo", function() require("telescope.builtin").oldfiles() end, "Find history")
nnoremap("<leader>fs", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, "Find Symbols")
-- maps.n["<leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
nnoremap("<leader>ft", function() require("telescope.builtin").colorscheme { enable_preview = true } end, "Find themes")
nnoremap("<leader>fw", function()
  require("telescope").extensions.live_grep_args.live_grep_args {
    file_ignore_patterns = { "%node_modules/", "%.git/", "%env/", ".npz", ".png", ".jpg", ".webp" },
    -- additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
  }
end, "Find words")
nnoremap("<leader>fW", function()
  local cword = vim.fn.expand "<cword>"
  require("telescope").extensions.live_grep_args.live_grep_args {
    default_text = cword,
    file_ignore_patterns = { "%node_modules/", "%.git/", "%env/", ".npz", ".png", ".jpg", ".webp" },
    -- additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
  }
end, "Find words under cursor")
nnoremap("<leader>ls", function()
  local aerial_avail, _ = pcall(require, "aerial")
  if aerial_avail then
    require("telescope").extensions.aerial.aerial()
  else
    require("telescope.builtin").lsp_document_symbols()
  end
end, "Search symbols")
