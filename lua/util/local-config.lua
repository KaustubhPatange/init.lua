-- ~/config/.nvim/lua/util/local-config.lua
--
-- Loads a `config.lua` file from the project root automatically.
--
-- Search order (first match wins):
--   1. {project_root}/config.lua
--   2. {project_root}/.vscode/config.lua
--   3. Any parent directory walking up from cwd
--
-- Setup in init.lua:
--   require("util.local-config").setup()

local M = {}

-- Ordered list of relative paths to check within a directory
local SEARCH_PATHS = {
  ".lua",
  ".vscode/.lua",
}

-- Walk up from `start_dir` finding the project root via common markers
---@param start_dir string
---@return string
local function find_project_root(start_dir)
  local markers = { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml", ".nvim.lua" }
  local path = start_dir

  while path ~= "/" do
    for _, marker in ipairs(markers) do
      if vim.fn.filereadable(path .. "/" .. marker) == 1
          or vim.fn.isdirectory(path .. "/" .. marker) == 1
      then
        return path
      end
    end
    path = vim.fn.fnamemodify(path, ":h")
  end

  return start_dir -- fallback to start_dir if no root marker found
end

-- Search for config.lua in priority order within a root directory
---@param root string
---@return string|nil  full path to config.lua if found
local function find_config_file(root)
  for _, relative in ipairs(SEARCH_PATHS) do
    local candidate = root .. "/" .. relative
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
  end
  return nil
end

-- Execute a config file safely using vim.secure.read.
-- Respects Neovim's trust system — untrusted files prompt the user
-- exactly like exrc/.nvim.lua does.
---@param filepath string
local function exec(filepath)
  local content = vim.secure.read(filepath)
  if content == nil then
    -- user denied trust prompt or file unreadable — silently skip
    return
  end
  local fn, err = load(content, "@" .. filepath)
  if not fn then
    vim.notify("[local-config] Parse error in " .. filepath .. ":\n" .. err, vim.log.levels.ERROR)
    return
  end
  local ok, run_err = pcall(fn)
  if not ok then
    vim.notify("[local-config] Runtime error in " .. filepath .. ":\n" .. run_err, vim.log.levels.ERROR)
  end
end

-- Track which roots we've already loaded to avoid re-running on every BufEnter
local loaded = {}

-- Setup the loader. Call once in your init.lua.
function M.setup()
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("local_config_loader", { clear = true }),
    callback = function(args)
      -- args.buf may be invalid during early startup
      local ok, bufname = pcall(vim.api.nvim_buf_get_name, args.buf)
      if not ok then return end

      -- for unnamed/non-file buffers fall back to cwd
      local bufdir
      if bufname == "" or vim.fn.filereadable(bufname) == 0 then
        bufdir = vim.fn.getcwd()
      else
        bufdir = vim.fn.fnamemodify(bufname, ":h")
      end

      local root = find_project_root(bufdir)

      -- only load once per project root
      if loaded[root] then return end
      loaded[root] = true

      local cfg_path = find_config_file(root)
      if cfg_path then
        exec(cfg_path)
      end
    end,
  })
end

-- Manually reload config for the current buffer's project (useful for testing)
function M.reload()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    vim.notify("[local-config] No file in current buffer", vim.log.levels.WARN)
    return
  end

  local bufdir = vim.fn.fnamemodify(bufname, ":h")
  local root = find_project_root(bufdir)

  -- clear cache so it re-runs
  loaded[root] = nil

  local cfg_path = find_config_file(root)
  if cfg_path then
    vim.notify("[local-config] Reloading " .. cfg_path, vim.log.levels.INFO)
    exec(cfg_path)
    loaded[root] = true
  else
    vim.notify("[local-config] No config.lua found in " .. root, vim.log.levels.WARN)
  end
end

return M
