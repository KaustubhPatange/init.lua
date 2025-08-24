-- Add/Edit the server names
local lsp_servers = { "ts_ls", "eslint@4.8.0", "rust_analyzer", "lua_ls", "pyright", "biome" }

local formatters = require('kp.plugins.config.lsp.formatters')
formatters.setup()


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

  formatters.attach_mappings()

  -- Organize imports
  local clients_commands = {
    pyright = "pyright.organizeimports",
    ts_ls = "_typescript.organizeImports",
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


-- Configure LSP settings
require("mason").setup {}
require("mason-lspconfig").setup {
  ensure_installed = lsp_servers,
  automatic_installation = false,
  automatic_enable = false,
  handlers = {}
}

-- LSP Configs
local lsp_util = require("lspconfig.util")

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})
vim.lsp.enable("gopls")

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        -- diagnosticMode = "workspace",
      },
    },
  },
})
vim.lsp.enable("pyright")

vim.lsp.config("eslint", {
  cmd_env = {
    NODE_OPTIONS = "--max-old-space-size=8192"
  },
  settings = {
    codeAction = {
      showDocumentation = {
        enable = false
      }
    },
    codeActionOnSave = {
      enable = false
    },
    format = false,
    quiet = false,
  }
})
vim.lsp.enable("eslint")

local lua_opts = lsp_zero.nvim_lua_ls()
vim.lsp.config("lua_ls", {
  require("lspconfig").lua_ls.setup(lua_opts)

})
vim.lsp.enable("lua_ls")

vim.lsp.config("biome", {
  root_dir = lsp_util.root_pattern("biome.json", "biome.jsonc")
})
vim.lsp.enable("biome")

vim.lsp.enable("kotlin_lsp")

local ts_tools = require("kp.plugins.config.lsp.ts-tools")
ts_tools.setup()

local jdtls = require('kp.plugins.config.lsp.jdtls')
jdtls.setup()


-- CMP

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

local set_diagnostic_severity
set_diagnostic_severity = function()
  nnoremap("<leader>uD", function()
    local SEVERITY = vim.diagnostic.severity
    local configure = function(min, max, description)
      vim.diagnostic.severity_level = description

      local opts = {}
      if min == nil and max == nil then
        vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
      else
        if min ~= nil then opts.min = min end
        if max ~= nil then opts.max = max end

        local severity = { severity = opts }

        vim.diagnostic.config({ virtual_text = severity, signs = severity, underline = severity })
      end
      set_diagnostic_severity()
    end

    local current_selection = vim.diagnostic.severity_level or "all"

    local input = vim.fn.input(
      "\nCurrent: " ..
      current_selection ..
      "\n\n1. All (error, warning, info, hint)\n2. Error (error)\n3. Warning (warn)\n4. Info (info)\nd. Disable\n\nEnter option: ")
    if input == "1" then configure(SEVERITY.HINT, SEVERITY.ERROR, "all") end
    if input == "2" then configure(SEVERITY.ERROR, SEVERITY.ERROR, "error") end
    if input == "3" then configure(SEVERITY.WARN, SEVERITY.WARN, "warn") end
    if input == "4" then configure(SEVERITY.INFO, SEVERITY.INFO, "info") end
    if input == "d" then configure(nil, nil, "disabled") end
  end, "Set Diagnostics Severity (" .. (vim.diagnostic.severity_level or "all") .. ")")
end
set_diagnostic_severity()
