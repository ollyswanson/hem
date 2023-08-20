vim.opt.shortmess:append("c")

return {
  {
    -- TODO: This is a mess and I need to fix it as I don't think this is actually doing anything, lol
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")

      local luasnip_jump = function(dir)
        return function()
          if ls.jumpable(dir) then
            ls.jump(dir)
          else
            return ""
          end
        end
      end

      local jump_forward = luasnip_jump(1)
      local jump_backward = luasnip_jump(-1)

      ls.config.set_config({ history = false, updateevents = "TextChanged,TextChangedI" })
      require("luasnip.loaders.from_vscode").lazy_load({})

      local map = vim.keymap.set

      map("i", "<C-h>", jump_backward)
      map("i", "<C-l>", jump_forward)
      map("s", "<C-h>", jump_backward)
      map("s", "<C-l>", jump_forward)
      map("i", "<C-e>", function() if ls.choice_active() then ls.change_choice(1) end end)
      map("s", "<C-e>", function() if ls.choice_active() then ls.change_choice(1) end end)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")

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
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { name = "buffer" }),
      })
    end,
  }
}
