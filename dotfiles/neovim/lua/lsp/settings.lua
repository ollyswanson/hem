local ls_install_prefix = vim.fn.stdpath("data") .. "/mason"

-- TODO: Review whether completion should be moved somewhere else.
olsp = {
  diagnostics = {
    signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn",  text = "" },
      { name = "DiagnosticSignHint",  text = "" },
      { name = "DiagnosticSignInfo",  text = "" },
    },
  },
  completion = {
    item_kind = {
      "   (Text) ",
      "   (Method)",
      "   (Function)",
      "   (Constructor)",
      "   (Field)",
      "   (Variable)",
      "   (Class)",
      " ﰮ  (Interface)",
      "   (Module)",
      "   (Property)",
      " 塞 (Unit)",
      "   (Value)",
      " 練 (Enum)",
      "   (Keyword)",
      "   (Snippet)",
      "   (Color)",
      "   (File)",
      "   (Reference)",
      "   (Folder)",
      "   (EnumMember)",
      " ﲀ  (Constant)",
      "   (Struct)",
      "   (Event)",
      "   (Operator)",
      "   (TypeParameter)",
    },
  },
  -- Language servers for rust and C/C++ are set up using the relevant language tools plugins
  lang = {
    bash = {
      lsp = {
        provider = "bashls",
        setup = {}
      }
    },
    lua = {
      lsp = {
        provider = "lua_ls",
        setup = {
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim", "use", "olsp" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 1000,
              },
            },
          },
        },
      },
    },
    nix = {
      lsp = {
        provider = "rnix",
        setup = {},
      }
    },
    typescript = {
      lsp = {
        provider = "tsserver",
        setup = {
          cmd = { "typescript-language-server", "--stdio" },
          filetypes = {
            "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
            "typescript.tsx"
          },
        },
        settings = {},
        -- client, bufnr
        lang_on_attach = function(client, _)
          client.server_capabilities.document_formatting = false
        end
      }
    },
    python = {
      lsp = {
        provider = "pyright",
        settings = {},
        setup = {
          cmd = { "pyright-langserver", "--stdio" }
        },
      },
    }
  },
}
