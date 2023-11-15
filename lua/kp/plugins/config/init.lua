local sections = {
  f = { name = "󰍉 Find" },
  -- p = { name = "󰏖 Packages" },
  l = { name = " LSP" },
  u = { name = " UI" },
  b = { name = "󰓩 Buffers" },
  -- d = { name = " Debugger" },
  g = { name = " Git" },
  -- S = { name = "󱂬 Session" },
  t = { name = " Terminal" },
}

local function set_default_maps()
  --Default mappings
  nnoremap("|", "<cmd>vsplit<cr>", "Vertical Split")
  nnoremap("-", "<cmd>split<cr>", "Horizontal Split")
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
