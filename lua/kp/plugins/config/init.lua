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

vim.api.nvim_create_autocmd({ "User" }, {
  callback = function(ev)
    if ev.file == "LazyDone" then
      for k, v in pairs(sections) do
        secmap("<leader>" .. k, v["name"])
      end
    end
  end,
})

return {}
