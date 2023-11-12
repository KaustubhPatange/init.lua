
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


