-- A utility for adding remap (Normal mode)
function nnoremap(key, command, desc, opts)
  if desc then
    local wk = require "which-key"
    local opt = { key, command, desc = desc, mode = "n" }
    wk.add({ extend_tbl(opt, opts or {}) })
  else
    vim.keymap.set("n", key, command, opts or {})
  end
end

-- A utility for adding remap (Visual mode)
function vnoremap(key, command, desc, opts)
  if desc then
    local wk = require "which-key"
    local opt = { key, command, desc =desc, mode = "v" }
    wk.add({ extend_tbl(opt, opts or {}) })
  else
    vim.keymap.set("v", key, command, opts or {})
  end
end

function secmap(key, desc)
  local wk = require "which-key"
  wk.add({ { key, desc = desc, prefix = "" } })
end
