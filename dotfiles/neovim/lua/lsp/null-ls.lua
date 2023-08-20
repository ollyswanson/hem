local null_ls = require("null-ls")
local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
function M.setup()
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions

  null_ls.setup({
    sources = {
      formatting.prettierd,
      formatting.terrafmt,
      code_actions.eslint_d,
      diagnostics.flake8,
      formatting.black,
      formatting.isort,
      formatting.shfmt,
    },
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
  })
end

return M
