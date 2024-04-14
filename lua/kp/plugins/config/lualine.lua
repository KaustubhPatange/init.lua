local conform = require "conform"

local function list_formatters()
  local f = conform.list_formatters(0)
  local fmts = {}
  for _, v in pairs(f) do
    if v.available then table.insert(fmts, v.name) end
  end
  return table.concat(fmts, ", ")
end

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "neo-tree" },
      winbar = { "neo-tree" },
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename", { "macro-recording", fmt = show_macro_recording }, "lsp_progress" },
    lualine_x = {
      {
        "searchcount",
        maxcount = 999,
        timeout = 500,
      },
      "filetype",
      "lsp",
      list_formatters,
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
