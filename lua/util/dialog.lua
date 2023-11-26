local M = {}

function M.display_info(message) vim.notify(message, nil, { timeout = 0 }) end

return M
