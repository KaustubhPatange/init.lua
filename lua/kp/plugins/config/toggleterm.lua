require("toggleterm").setup {
  size = 10,
  open_mapping = [[<F7>]],
  on_open = function(term)
    vim.cmd "startinsert!"
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  shading_factor = 2,
  direction = "float",
  float_opts = {
    border = "curved",
    highlights = { border = "Normal", background = "Normal" },
  },
}

local terminals = {}
local function toggle_term_cmd(opts)
  local terms = terminals
  -- if a command string is provided, create a basic table for Terminal:new() options
  if type(opts) == "string" then opts = { cmd = opts, hidden = true } end
  -- if terminal doesn't exist yet, create it
  if not terms[opts.cmd] then
    if not opts.on_exit then opts.on_exit = function() terms[opts.cmd] = nil end end
    terms[opts.cmd] = require("toggleterm.terminal").Terminal:new(opts)
  end
  -- toggle the terminal
  terms[opts.cmd]:toggle()
end

-- Mappings
if vim.fn.executable "lazygit" == 1 then
  nnoremap("<leader>gg", function() toggle_term_cmd "lazygit" end, "ToggleTerm lazygit")
  nnoremap("<leader>tl", function() toggle_term_cmd "lazygit" end, "ToggleTerm lazygit")
end
if vim.fn.executable "node" == 1 then
  nnoremap("<leader>tn", function() toggle_term_cmd "node" end, "ToggleTerm node")
end
if vim.fn.executable "gdu" == 1 then nnoremap("<leader>tu", function() toggle_term_cmd "gdu" end, "ToggleTerm gdu") end
if vim.fn.executable "btm" == 1 then nnoremap("<leader>tt", function() toggle_term_cmd "btm" end, "ToggleTerm btm") end
local python = vim.fn.executable "python" == 1 and "python" or vim.fn.executable "python3" == 1 and "python3"
if python then nnoremap("<leader>tp", function() toggle_term_cmd(python) end, "ToggleTerm python") end
nnoremap("<leader>tb", "<cmd>terminal<cr>", "Open terminal in new buffer")
-- maps.t["<esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" }
nnoremap("<leader>tf", "<cmd>ToggleTerm direction=float<cr>", "ToggleTerm float")
nnoremap("<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "ToggleTerm horizontal split")
nnoremap("<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", "ToggleTerm vertical split")
nnoremap("<F7>", "<cmd>ToggleTerm<cr>", "Toggle terminal")

-- vim.keymap.set("t", "<esc>", "<C-\\><C-n>")
