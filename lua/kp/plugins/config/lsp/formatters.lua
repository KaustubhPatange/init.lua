local M = {}

local formatters = {
  go = { "gofmt", "goimports" },
  lua = { "stylua" },
  python = { "isort", "black" },
  javascript = { "prettier", "biome" },
  typescript = { "prettier", "biome" },
  javascriptreact = { "prettier", "biome" },
  typescriptreact = { "prettier", "biome" },
}

local conform = require "conform"

local util = require("conform.util")

conform.formatters.biome = {
  command = "biome",
  args = { "format", "--stdin-file-path", "$FILENAME" },
  cwd = util.root_file({ "biome.json", "biome.jsonc" }),
  require_cwd = true,
}

function M.setup()
  -- Conform for formatting buffers
  local slow_format_filetypes = {}
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
end

function M.attach_mappings()
  nnoremap("<leader>lf", function() conform.format { async = true, lsp_fallback = true } end, "Format buffer")
  vnoremap("<leader>lf", function() conform.format { async = true, lsp_fallback = true } end, "Format selected lines")
end

return M
