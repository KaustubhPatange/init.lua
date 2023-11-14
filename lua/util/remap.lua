-- A utility for adding remap (Normal mode)
function nnoremap(key, command, desc, opts)
  if desc then
    local wk = require("which-key")
    wk.register({
      [key] = { command, desc }
    }, extend_tbl(opts or {}, {mode="n"}))
  else
    vim.keymap.set("n", key, command, opts or {})
  end
end

-- A utility for adding remap (Visual mode)
function vnoremap(key, command, desc, opts)
  if desc then
    local wk = require("which-key")
    wk.register({
      [key] = { command, desc }
    }, extend_tbl(opts or {}, {mode = "v"}))
  else
    vim.keymap.set("v", key, command, opts or {})
  end
end

function secmap(key, desc)
  local wk = require("which-key")
  wk.register({
    [key] = { desc }
  })
end
