local M = {}

M.OSMAP = {
  LINUX = "Linux",
  MAC = "macOS",
  MAC_ARM = "macOS (ARM)",
  WINDOWS = "Windows",
  UNKNOWN = "Unknown"
}

function M.get_osmap()
  local os_name = vim.loop.os_uname().sysname

  if os_name == "Linux" then
    return M.OSMAP.LINUX
  elseif os_name == "Darwin" then
    -- Check for ARM architecture
    local arch = vim.loop.os_uname().machine
    if arch == "arm64" then
      return M.OSMAP.MAC_ARM
    else
      return M.OSMAP.MAC
    end
  elseif os_name == "Windows" then
    return M.OSMAP.WINDOWS
  else
    return M.OSMAP.UNKNOWN
  end
end

return M
