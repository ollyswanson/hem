local rust_on_attach = function(_, bufnr)
  local rt = require("rust-tools")

  local map = vim.keymap.set

  map("n", "<leader>rr", rt.runnables.runnables, { desc = "Runnables", buffer = bufnr })
  map("n", "<leader>rm", rt.expand_macro.expand_macro, { desc = "Expand macro", buffer = bufnr })
  map("n", "<leader>ru", function() rt.move_item.move_item(true) end, { desc = "Move item up", buffer = bufnr })
  map("n", "<leader>rd", function() rt.move_item.move_item(false) end, { desc = "Move item down", buffer = bufnr })
  map("n", "<leader>ra", rt.hover_actions.hover_actions, { desc = "Hover actions", buffer = bufnr })
  map("v", "<leader>ra", rt.hover_range.hover_range, { desc = "Hover range", buffer = bufnr })
  map("n", "<leader>rc", rt.open_cargo_toml.open_cargo_toml, { desc = "Cargo.toml", buffer = bufnr })
  map("n", "<leader>rp", rt.parent_module.parent_module, { desc = "Parent module", buffer = bufnr })
  map("n", "<leader>rj", rt.join_lines.join_lines, { desc = "Join lines", buffer = bufnr })
  -- TODO: Structural search replace
  -- TODO: View crate graph
end

local opts = {
  tools = { -- rust-tools options
    autoSetHints = true,
    inlay_hints = {
      only_current_line = false,
      show_parameter_hints = true,
      -- prefix for parameter hints
      parameter_hints_prefix = "◄",
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = "❯❯",
      max_len_align = true,
      max_len_align_padding = 4,
    },
  },
  server = {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
    on_attach = require("lsp").make_on_attach(rust_on_attach),
    settings = {
      ["rust-analyzer"] = {
        imports = {
          granularity = {
            group = "module"
          }
        },
        cargo = {
          allFeatures = true,
          buildScripts = {
            enable = true,
          }
        },
        -- enable clippy on save
        checkOnSave = {
          command = "clippy",
        },
        procMacro = {
          enable = true,
        },
        features = "all"
      },
    },
  },
}


return
{
  "simrat39/rust-tools.nvim",
  opts = opts
}
