local M = {}

local cmp = require("cmp")
local utils = require("utils")

function M.cmp_setup()
  vim.cmd([[set shortmess+=c]])

  utils.augroup(
    "lua_completion",
    [[
    autocmd FileType lua lua require('cmp').setup.buffer({sources={{name = 'buffer'},{name = 'nvim_lsp'},{name = 'nvim_lua'}}})
    ]]
  )

  cmp.setup({
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
  })
end

return M
