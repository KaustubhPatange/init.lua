local telescope = require("telescope")
local actions = require("telescope.actions")
local icons = require("util.icons")

telescope.setup({
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
      },
  }
  )
telescope.load_extension("fzf")


-- Mappings
nnoremap("<leader>gb", function() require("telescope.builtin").git_branches() end, "Git branches" )
nnoremap("<leader>gc", function() require("telescope.builtin").git_commits() end, "Git commits" )
nnoremap("<leader>gt", function() require("telescope.builtin").git_status() end, "Git status" )
nnoremap("<leader>f<CR>", function() require("telescope.builtin").resume() end, "Resume previous search" )
nnoremap("<leader>f'", function() require("telescope.builtin").marks() end, "Find marks" )
nnoremap("<leader>fb", function() require("telescope.builtin").buffers() end, "Find buffers" )
nnoremap("<leader>fC", function() require("telescope.builtin").commands() end, "Find commands" )
nnoremap("<leader>ff", function() require("telescope.builtin").find_files() end, "Find files" )
nnoremap("<leader>fF", 
  function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
  "Find all files"
)
nnoremap("<leader>fh", function() require("telescope.builtin").help_tags() end, "Find help" )
nnoremap("<leader>fk", function() require("telescope.builtin").keymaps() end, "Find keymaps" )
nnoremap("<leader>fm", function() require("telescope.builtin").man_pages() end, "Find man" )
nnoremap("<leader>fo", function() require("telescope.builtin").oldfiles() end, "Find history" )
nnoremap("<leader>fs", 
  function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
  "Find Symbols"
)
-- maps.n["<leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
nnoremap("<leader>fr", "<cmd>lua require('spectre').open()<cr>", "Search and replace" )
nnoremap("<leader>fR", 
  "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
  "Search and replace current word"
)
nnoremap("<leader>ft", 
   function() require("telescope.builtin").colorscheme { enable_preview = true } end,
   "Find themes" 
)
nnoremap("<leader>fw", 
  function()
    require("telescope.builtin").live_grep {
      file_ignore_patterns = { "node_modules", ".git", "env" },
      additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
    }
  end,
  "Find words"
)
nnoremap("<leader>fW",
  function()
    local cword = vim.fn.expand "<cword>"
    require("telescope.builtin").live_grep {
      default_text = cword,
      file_ignore_patterns = { "node_modules", ".git", "env" },
      additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
    }
  end,
  "Find words under cursor"
)
nnoremap("<leader>lD", function() require("telescope.builtin").diagnostics() end, "Search diagnostics" )
nnoremap("<leader>ls", 
  function()
    local aerial_avail, _ = pcall(require, "aerial")
    if aerial_avail then
      require("telescope").extensions.aerial.aerial()
    else
      require("telescope.builtin").lsp_document_symbols()
    end
  end,
  "Search symbols"
 )

