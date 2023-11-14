local s = {
  {
    available = false,
    available_msg = "Command not found",
    command = "black",
    name = "black",
  },
  {
    available = false,
    available_msg = "Command not found",
    command = "isort",
    name = "isort",
  },
  {
    available = false,
    available_msg = "Command not found",
    command = "prettier",
    name = "prettier",
  },
  {
    available = true,
    command = "stylua",
    cwd = "/Users/devel/.config/nvim",
    name = "stylua",
  },
}

local function list_formatters()
  local f = s
  local fmts = {}
  for _, v in pairs(f) do
    if v.available then table.insert(fmts, v.name) end
  end
  return fmts
end

print(list_formatters())
