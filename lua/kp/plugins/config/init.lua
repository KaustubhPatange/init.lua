local sections = {
  f = { name = "󰍉 Find" },
  -- p = { name = "󰏖 Packages" },
  l = { name = " LSP" },
  u = { name = " UI" },
  b = { name = "󰓩 Buffers" },
  d = { name = " Debugger" },
  g = { name = " Git" },
  -- S = { name = "󱂬 Session" },
  t = { name = " Terminal" },
}

local function set_default_maps()
  --Default mappings
  nnoremap("|", "<cmd>vsplit<cr>", "Vertical Split")
  nnoremap("-", "<cmd>split<cr>", "Horizontal Split")

  local toggle_wrap
  toggle_wrap = function()
    local get_status = function(value)
      value = not value
      if value then
        return "disabled"
      else
        return "enabled"
      end
    end

    nnoremap("<leader>uw", function()
      vim.wo.wrap = not vim.wo.wrap
      toggle_wrap()
    end, "Toggle Wrap (" .. get_status(vim.wo.wrap) .. ")")
  end
  toggle_wrap()

  nnoremap("<leader>n", "<cmd>enew<cr>", "New File")

  vnoremap("J", ":m '>+1<CR>gv=gv", "Move selected lines up")
  vnoremap("K", ":m '<-2<CR>gv=gv", "Move selected lines down")

  nnoremap("+", "<cmd>horizontal resize +5<cr>", "Increase height")
  nnoremap("-", "<cmd>horizontal resize -5<cr>", "Decrease height")
  nnoremap(">>", "<cmd>vertical resize +5<cr>", "Increase width")
  nnoremap("<<", "<cmd>vertical resize -5<cr>", "Decrease width")
end

vim.api.nvim_create_autocmd({ "User" }, {
  callback = function(ev)
    if ev.file == "LazyDone" then
      for k, v in pairs(sections) do
        secmap("<leader>" .. k, v["name"])
      end
      set_default_maps()
    end
  end,
})

return {}
