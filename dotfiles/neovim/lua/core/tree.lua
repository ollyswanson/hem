local M = {}

function M.setup()
  require("nvim-tree").setup({
    disable_netrw = false,
    hijack_netrw = true,
  })
end

return M
