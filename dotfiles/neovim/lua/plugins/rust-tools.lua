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
    on_attach = require("lsp").make_on_attach(nil),
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

return {
  "simrat39/rust-tools.nvim",
  opts = opts
}
