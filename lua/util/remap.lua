-- A utility for adding remap (Normal mode)
function nnoremap(key, command, desc)
  if desc then
    local wk = require("which-key")
    wk.register({
      [key] = { command, desc }
    })
  else
    vim.keymap.set("n", key, command)
  end
end

function vnoremap(key, command, desc)
  if desc then
    local wk = require("which-key")
    wk.register({
      [key] = { command, desc }
    }, {mode = "v"})
  else
    vim.keymap.set("v", key, command)
  end
end

function secmap(key, desc)
  local wk = require("which-key")
  wk.register({
    [key] = { desc }
  })
end
