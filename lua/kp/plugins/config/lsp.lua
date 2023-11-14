-- Add/Edit the server names
local lsp_servers = { "tsserver", "rust_analyzer", "lua_ls", "pyright" }
local formatters = {
  lua = { "stylua" },
  python = { "isort", "black" },
  javascript = { "prettier" },
  typescript = { "prettier" },
}

-- Conform for formatting buffers
require("conform").setup {
  formatters_by_ft = formatters,
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
}

-- Special keymaps on current buffer based on lsp client
local lsp_zero = require "lsp-zero"
lsp_zero.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  nnoremap("gd", function() vim.lsp.buf.definition() end, "Go to definition", opts)
  nnoremap("K", function() vim.lsp.buf.hover() end, "Show definition", opts)
  nnoremap("<leader>lS", function() vim.lsp.buf.workspace_symbol() end, "Search workspace symbol", opts)
  nnoremap("<leader>ld", function() vim.diagnostic.open_float() end, "Hover diagnostic", opts)
  nnoremap("[d", function() vim.diagnostic.goto_next() end, "Next diagnostic", opts)
  nnoremap("]d", function() vim.diagnostic.goto_prev() end, "Previous diagnostic", opts)
  nnoremap("<leader>la", function() vim.lsp.buf.code_action() end, "Code actions", opts)
  nnoremap("gr", function() vim.lsp.buf.references() end, "Find references", opts)
  nnoremap("<leader>lr", function() vim.lsp.buf.rename() end, "Rename Symbol", opts)
  nnoremap("<C-p>", function() vim.lsp.buf.signature_help() end, "Signature help", opts)

  -- Toggle format keymaps
  local setup_format_keymap
  setup_format_keymap = function()
    local function get_status(value)
      value = not not value
      if value then
        return "disabled"
      else
        return "enabled"
      end
    end

    nnoremap("<leader>uf", function(args)
      vim.b.disable_autoformat = not vim.b.disable_autoformat
      setup_format_keymap()
    end, "Toggle format buffer (" .. get_status(vim.b.disable_autoformat) .. ")", opts)
    nnoremap("<leader>uF", function(args)
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      setup_format_keymap()
    end, "Toggle format global (" .. get_status(vim.g.disable_autoformat) .. ")", opts)
  end
  setup_format_keymap()
end)

require("mason").setup {}
require("mason-lspconfig").setup {
  ensure_installed = lsp_servers,
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require("lspconfig").lua_ls.setup(lua_opts)
    end,
  },
}

local cmp = require "cmp"
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local lspkind = require "lspkind"

cmp.setup {
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = lspkind.cmp_format(),
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<C-space>"] = cmp.mapping.complete(),
  },
}
