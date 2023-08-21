local file_types =
"javascript,typescript,javascriptreact,typescriptreact,javascript.jsx,typescript.tsx,lua,yaml,java,c,cpp,nix"

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("spacing", { clear = true }),
  desc = "Set spacing for certain files",
  pattern = file_types,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("text_width", { clear = true }),
  desc = "Set spacing for certain files",
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 100
  end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("formatting", {}),
  desc = "Format buffer",
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Highlight selection on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})
