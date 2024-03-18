-- Add/Edit the server names
local lsp_servers = { "tsserver", "rust_analyzer", "lua_ls", "pyright" }
local formatters = {
  lua = { "stylua" },
  python = { "isort", "black" },
  javascript = { "prettier" },
  typescript = { "prettier" },
  javascriptreact = { "prettier" },
  typescriptreact = { "prettier" },
}

-- Conform for formatting buffers
local slow_format_filetypes = {}
local conform = require "conform"
conform.setup {
  formatters_by_ft = formatters,
  format_on_save = function(bufnr)
    if slow_format_filetypes[vim.bo[bufnr].filetype] then return end
    local function on_format(err)
      if err and err:match "timeout$" then slow_format_filetypes[vim.bo[bufnr].filetype] = true end
    end
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
    return { timeout_ms = 200, lsp_fallback = true }, on_format
  end,
  format_after_save = function(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then return end
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
    return { lsp_fallback = true }
  end,
}

-- Special keymaps on current buffer based on lsp client
local lsp_zero = require "lsp-zero"
lsp_zero.on_attach(function(client, bufnr)
  if client.name == "copilot" then return end

  local opts = { buffer = bufnr, remap = false }
  nnoremap("gd", function() vim.lsp.buf.definition() end, "Go to definition", opts)
  nnoremap("K", function() vim.lsp.buf.hover() end, "Show definition", opts)
  nnoremap("<leader>ld", function() vim.diagnostic.open_float() end, "Hover diagnostic", opts)
  nnoremap("]d", function() vim.diagnostic.goto_next() end, "Next diagnostic", opts)
  nnoremap("[d", function() vim.diagnostic.goto_prev() end, "Previous diagnostic", opts)
  nnoremap("<leader>la", function() vim.lsp.buf.code_action() end, "Code actions", opts)
  nnoremap("gr", function() vim.lsp.buf.references() end, "Find references", opts)
  nnoremap("<leader>lr", function() vim.lsp.buf.rename() end, "Rename Symbol", opts)
  nnoremap("<C-p>", function() vim.lsp.buf.signature_help() end, "Signature help", opts)
  nnoremap("<leader>lf", function() conform.format { async = true, lsp_fallback = true } end, "Format buffer")
  vnoremap("<leader>lf", function() conform.format { async = true, lsp_fallback = true } end, "Format selected lines")

  -- Organize imports
  local clients_commands = {
    pyright = "pyright.organizeimports",
    tsserver = "_typescript.organizeImports",
  }
  for name, command in pairs(clients_commands) do
    if client.name == name then
      vim.lsp.buf.organize_imports = function()
        vim.lsp.buf.execute_command { command = command, arguments = { vim.api.nvim_buf_get_name(0) } }
      end
      nnoremap("<leader>lo", function() vim.lsp.buf.organize_imports() end, "Organize imports", opts)
    end
  end

  -- Toggle buffer format keymaps
  local diag = require "util.dialog"
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
      diag.display_info("Format buffer: " .. get_status(vim.b.disable_autoformat))
    end, "Toggle format buffer (" .. get_status(vim.b.disable_autoformat) .. ")", opts)
    nnoremap("<leader>uF", function(args)
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      setup_format_keymap()
      diag.display_info("Global format buffer: " .. get_status(vim.b.disable_autoformat))
    end, "Toggle format global (" .. get_status(vim.g.disable_autoformat) .. ")", opts)
  end
  setup_format_keymap()
end)

require("mason").setup {}
require("mason-lspconfig").setup {
  ensure_installed = lsp_servers,
  handlers = {
    lsp_zero.default_setup,
    pyright = function()
      require("lspconfig").pyright.setup {
        settings = {
          python = {
            analysis = {
              -- diagnosticMode = "workspace",
            },
          },
        },
      }
    end,
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

-- Mappings

nnoremap("<leader>ll", function()
  local input = vim.fn.input "\n1. Restart LSP server\n2. Start LSP server\n3. Stop LSP server\n\nEnter option: "
  if input == "1" then vim.cmd "LspRestart" end
  if input == "2" then vim.cmd "LspStart" end
  if input == "3" then vim.cmd "LspStop" end
end, "LSP options")
