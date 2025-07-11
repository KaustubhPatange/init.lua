local adapter_names = { "python", "node2" }
require("dapui").setup {
  library = { plugins = { "nvim-dap-ui" }, types = true },
}
require("dap.ext.vscode").load_launchjs()

local filetypes = require "mason-nvim-dap.mappings.filetypes"
filetypes.node = filetypes.node2

local function set_adapter(adapter_name)
  local dap = require "dap"
  -- require("lazy").load { plugins = "nvim-dap" }
  local adapters = require "mason-nvim-dap.mappings.adapters"
  local configurations = require "mason-nvim-dap.mappings.configurations"

  local config = {
    name = adapter_name,
    adapters = adapters[adapter_name],
    configurations = configurations[adapter_name],
    filetypes = filetypes[adapter_name],
  }

  dap.adapters[config.name] = config.adapters
  -- For now, let's use same adapter for node
  if config.name == "node2" then
    dap.adapters["node"] = config.adapters
  end
  local configuration = config.configurations or {}
  if not vim.tbl_isempty(configuration) then
    for _, filetype in ipairs(config.filetypes) do
      dap.configurations[filetype] = vim.list_extend(dap.configurations[filetype] or {}, configuration)
    end
  end
end

local function dap_load_and_continue()
  require("dap.ext.vscode").load_launchjs()

  local dap = require "dap"
  local function load_for_node_filetype(type)
    if not filetypes[type] then
      return
    end
    for _, filetype in ipairs(filetypes[type]) do
      local dap_configs = dap.configurations[type] or {}
      for _, dap_config in ipairs(dap_configs) do
        -- Remove duplicate config if exists
        for i, config in ipairs(dap.configurations[filetype]) do
          if config.name == dap_config.name then
            table.remove(dap.configurations[filetype], i)
          end
        end
        -- Insert new config
        table.insert(dap.configurations[filetype], dap_config)
      end
    end
  end
  if dap.configurations.node or dap.configurations.node2 then
    load_for_node_filetype("node")
    load_for_node_filetype("node2")
  end

  require("dap").continue()
end

local mason_dap = require "mason-nvim-dap"
mason_dap.setup {
  ensure_installed = adapter_names,
}
for _, adapter_name in ipairs(adapter_names) do
  set_adapter(adapter_name)
end

local dap, dapui = require "dap", require "dapui"
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- Symbols
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  desc = "prevent colorscheme clears self-defined DAP icon colors.",
  callback = function()
    vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939" })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { ctermbg = 0, fg = "#fdc12a" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })
  end,
})

vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "⬤", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })

-- Mappings
nnoremap("<leader>dc", dap_load_and_continue, "Launch/Continue")
nnoremap("<leader>do", function() require("dap").step_over() end, "Step Over")
nnoremap("<leader>di", function() require("dap").step_into() end, "Step Into")
nnoremap("<leader>de", function() require("dap").step_out() end, "Step Out")
nnoremap("<Leader>db", function() require("dap").toggle_breakpoint() end, "Toggle breakpoint")
nnoremap(
  "<leader>dB",
  function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
  "Breakpoint Condition"
)
nnoremap("<Leader>dt", function()
  require("dap").terminate()
  require('dapui').close()
end, "Terminate")
nnoremap("<leader>dp", function() require("dap").pause() end, "Pause")
nnoremap("<leader>du", function() require("dapui").toggle() end, "Toggle DAP UI ")
nnoremap("<leader>dr", function()
  local windows = require('dapui.windows')
  for _, win_layout in ipairs(windows.layouts) do
    win_layout:close()
    win_layout:resize()
  end
end, "Reset DAP UI")
nnoremap("<leader>dC", function() require("dap").run_to_cursor() end, "Run to Cursor")
-- nnoremap("<Leader>dB", function() require("dap").set_breakpoint() end)
-- nnoremap("<Leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ") end)
-- nnoremap("<Leader>dr", function() require("dap").repl.open() end)
-- nnoremap("<Leader>dl", function() require("dap").run_last() end)
-- nnoremap({ "v" }, "<Leader>dh", function() require("dap.ui.widgets").hover() end)
-- nnoremap({ "v" }, "<Leader>dp", function() require("dap.ui.widgets").preview() end)
-- nnoremap("<Leader>df", function()
--   local widgets = require "dap.ui.widgets"
--   widgets.centered_float(widgets.frames)
-- end)
-- nnoremap("<Leader>ds", function()
--   local widgets = require "dap.ui.widgets"
--   widgets.centered_float(widgets.scopes)
-- end)
