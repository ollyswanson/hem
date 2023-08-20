local prettier = function()
  return { exe = "prettier", args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) }, stdin = true }
end

-- this can all be replaced with null-ls
local rustfmt = function()
  return { exe = "rustfmt", args = { "--emit=stdout" }, stdin = true }
end

require("formatter").setup({
  logging = false,
  filetype = {
    css = { prettier },
    less = { prettier },
    sass = { prettier },
    scss = { prettier },
    json = { prettier },
    markdown = { prettier },
    yaml = {
      function()
        return {
          exe = "prettier",
          args = { "--single-quote", "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },
    html = { prettier },
    rust = {
      function()
        return { exe = "rustfmt", args = { "--emit=stdout", "--edition=2018" }, stdin = true }
      end,
    },
  },
})

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.css,*.scss,*.json,*.md,*.yaml,*.yml,*.html,*.rs FormatWrite
augroup END
]],
  true
)
