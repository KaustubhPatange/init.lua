local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
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
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'rust_analyzer', 'lua_ls', 'pyright'},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local lspkind = require('lspkind')

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    -- changing the order of fields so the icon is the first
    format = lspkind.cmp_format()
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.complete(),
  }),
})

