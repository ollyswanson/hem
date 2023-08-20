vim.g.mapleader = " "

require("core")
require("settings")
require("mappings").define_mappings()
require("lsp").setup()

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('formatting', {}),
  desc = 'Format buffer',
  pattern = '*',
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Highlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
  end,
})
