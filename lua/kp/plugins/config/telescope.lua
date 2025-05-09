local telescope = require "telescope"
local actions = require "telescope.actions"
local icons = require "util.icons"
local lga_actions = require "telescope-live-grep-args.actions"
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

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
        ["<C-t>"] = lga_actions.quote_prompt(),
        ["<C-y>"] = function()
          local entry = require("telescope.actions.state").get_selected_entry()
          if not entry then return end
          local data = entry.text and require('util.str').trim(entry.text) or entry[1]
          local cb_opts = vim.opt.clipboard:get()
          if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", data) end
          if vim.tbl_contains(cb_opts, "unnamedplus") then
            vim.fn.setreg("+", data)
          end
          vim.fn.setreg("+", data) -- default to system clipboard
        end,
        ["<C-space>"] = actions.to_fuzzy_refine,
      },
      n = { ["q"] = actions.close },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = false,
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

local live_grep_opts = {
  file_ignore_patterns = { "%node_modules/", "%.git/", "%.aider/", "%.cache/", ".aider.chat", ".npz", ".png", ".jpg", ".webp" },
}

nnoremap("<leader>ft", function() require("telescope.builtin").colorscheme { enable_preview = true } end, "Find themes")
nnoremap("<leader>fw", function()
  require("telescope").extensions.live_grep_args.live_grep_args(live_grep_opts)
end, "Find words")

vnoremap("<leader>fw", function()
  live_grep_args_shortcuts.grep_visual_selection(live_grep_opts)
end, "Find words")

nnoremap("<leader>ls", function()
  local aerial_avail, _ = pcall(require, "aerial")
  if aerial_avail then
    require("telescope").extensions.aerial.aerial()
  else
    require("telescope.builtin").lsp_document_symbols()
  end
end, "Search symbols")
