return {
  "p00f/clangd_extensions.nvim",
  opts = {
    server = {
      cmd = { vim.fn.stdpath("data") .. "/mason/bin/clangd" },
      on_attach = require("lsp").make_on_attach(nil),
    }
  }
}
