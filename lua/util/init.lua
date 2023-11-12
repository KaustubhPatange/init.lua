function extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

require("util.remap")
