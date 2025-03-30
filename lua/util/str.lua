local M = {}

function M.trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return M
