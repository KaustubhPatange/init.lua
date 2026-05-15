local M = {}

function M.deep_merge(base, patch)
  local result = vim.deepcopy(base)
  for k, v in pairs(patch) do
    if type(v) == "table" and type(result[k]) == "table" and not vim.islist(v) then
      result[k] = M.deep_merge(result[k], v)
    else
      result[k] = vim.deepcopy(v)
    end
  end
  return result
end

function M.detach_clients_on_buffer(bufnr)
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    vim.lsp.buf_detach_client(bufnr, client.id)
  end
end

return M
