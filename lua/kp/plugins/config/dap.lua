require("dapui").setup {
  library = { plugins = { "nvim-dap-ui" }, types = true },
}
require("mason-nvim-dap").setup {
  ensure_installed = { "python" },
  handlers = {},
}

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
    vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })
  end,
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped" })

-- Mappings
nnoremap("<leader>dc", function() require("dap").continue() end, "Launch/Continue")
nnoremap("<leader>do", function() require("dap").step_over() end, "Step Over")
nnoremap("<leader>di", function() require("dap").step_into() end, "Step Into")
nnoremap("<leader>de", function() require("dap").step_out() end, "Step Out")
nnoremap("<Leader>db", function() require("dap").toggle_breakpoint() end, "Toggle breakpoint")
nnoremap("<Leader>dt", function() require("dap").terminate() end, "Terminate")
nnoremap("<leader>dp", function() require("dap").pause() end, "Pause")
nnoremap("<leader>du", function() require("dapui").toggle() end, "Toggle DAP UI ")
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
