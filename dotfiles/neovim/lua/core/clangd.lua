local M = {}

local opts = {
  server = {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/clangd" },
    on_attach = require("lsp").make_on_attach(nil),
  }
}

M.setup = function()
  require("clangd_extensions").setup(opts)
end

return M
