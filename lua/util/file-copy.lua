local M = {}

---@param mods string filename-modifiers
---@return string
local function get_path(mods)
  return vim.fn.fnamemodify(vim.fn.expand("%"), mods)
end

local function copy_to_clipboard(path)
  vim.fn.setreg("+", path)
end

function M.get_relative_path()
  return get_path(":.")
end

function M.get_absolute_path()
  return get_path(":p")
end

function M.get_relative_home_path()
  return get_path(":~")
end

function M.get_file_name()
  return get_path(":t")
end

function M.get_extension()
  return get_path(":e")
end

function M.get_absolute_path_uri()
  local path = get_path(":~")
  return "file://" .. vim.fn.escape(path, " ")
end

function M.open_file_copy_selector()
  local basename = M.get_file_name()
  local extension = M.get_extension()
  local filename = basename .. "." .. extension
  local absolute_path = M.get_absolute_path()
  local relative_path = M.get_relative_path()
  local relative_home_path = M.get_relative_home_path()
  local uri = M.get_absolute_path_uri()

  -- Create a message string
  local message = table.concat({
    "",
    "1: BASENAME: " .. basename,
    "2: EXTENSION: " .. extension,
    "3: FILENAME: " .. filename,
    "4: PATH: " .. absolute_path,
    "5: PATH (CWD): " .. relative_path,
    "6: PATH (HOME): " .. relative_home_path,
    "7: URI: " .. uri,
    "Type number and <Enter> or click with the mouse (q or empty cancels): "
  }, "\n")

  -- Get user input
  local input = vim.fn.input(message)

  -- Handle user input
  if input == "1" then
    copy_to_clipboard(basename)
  elseif input == "2" then
    copy_to_clipboard(extension)
  elseif input == "3" then
    copy_to_clipboard(filename)
  elseif input == "4" then
    copy_to_clipboard(absolute_path)
  elseif input == "5" then
    copy_to_clipboard(relative_path)
  elseif input == "6" then
    copy_to_clipboard(relative_home_path)
  elseif input == "7" then
    copy_to_clipboard(uri)
  elseif input == "q" or input == "" then
    -- Cancel action
    return
  else
    vim.api.nvim_echo({ { "Invalid option selected." } }, false, {})
  end
end

return M
