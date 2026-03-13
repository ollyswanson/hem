local M = {}

-- ==============================================================================
-- Diagnostic Configuration
-- ==============================================================================

local diagnostic_signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

local function setup_diagnostics()
  for _, sign in ipairs(diagnostic_signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.diagnostic.config({
    virtual_text = true,
    signs = { active = true },
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })
end

-- ==============================================================================
-- LSP Keybindings (aligned with zed vim-mode)
-- ==============================================================================

-- Keybindings are set via LspAttach autocmd so they only apply in buffers
-- where an LSP client is active.
local function setup_keybindings()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_keybindings", { clear = true }),
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local map = vim.keymap.set
      local builtin = require("telescope.builtin")
      local opts = function(desc) return { buffer = bufnr, desc = desc } end

      -- Hover and signature help
      map("n", "K", vim.lsp.buf.hover, opts("hover"))
      map("i", "<C-g>", vim.lsp.buf.signature_help, opts("signature help"))

      -- Code actions (zed: g.)
      map("n", "g.", vim.lsp.buf.code_action, opts("code actions"))

      -- Navigation
      map("n", "gd", builtin.lsp_definitions, opts("definition"))
      map("n", "gD", vim.lsp.buf.declaration, opts("declaration"))
      map("n", "gi", builtin.lsp_implementations, opts("implementation"))
      map("n", "gt", builtin.lsp_type_definitions, opts("type definition"))

      -- References (zed: gA, keep gr too)
      map("n", "gA", builtin.lsp_references, opts("all references"))
      map("n", "gr", builtin.lsp_references, opts("references"))

      -- Symbols (zed: gs / gS)
      map("n", "gs", builtin.lsp_document_symbols, opts("document symbols"))
      map("n", "gS", builtin.lsp_workspace_symbols, opts("workspace symbols"))

      -- Diagnostics (zed: gh / ]d / [d)
      map("n", "gh", vim.diagnostic.open_float, opts("diagnostic float"))
      map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts("next diagnostic"))
      map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts("prev diagnostic"))

      -- Rename
      map("n", "<leader>rn", vim.lsp.buf.rename, opts("rename"))

      -- Type definition
      map("n", "<leader>D", vim.lsp.buf.type_definition, opts("type definition"))

      -- Workspace folders
      map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("add folder"))
      map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("remove folder"))
      map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts("list folders"))

      -- Trouble
      map("n", "<leader>xx", "<cmd>Trouble diagnostics<CR>", opts("trouble"))
      map("n", "<leader>xd", "<cmd>Trouble diagnostics filter.buf=0<CR>", opts("buffer diagnostics"))

      -- Format
      if client and client.supports_method("textDocument/formatting") then
        map("n", "<leader>ff", vim.lsp.buf.format, opts("format"))
      end
    end,
  })
end

-- ==============================================================================
-- Server Setup (native nvim 0.11 vim.lsp.config / vim.lsp.enable)
-- ==============================================================================

local function make_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

-- Servers are only enabled if the binary is found on PATH (nix provides them).
local servers = {
  nixd = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
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
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
        cargo = { allFeatures = true },
      },
    },
  },
  pyright = {},
  ts_ls = {},
  bashls = {},
}

function M.setup()
  setup_diagnostics()
  setup_keybindings()

  local capabilities = make_capabilities()
  local to_enable = {}

  for name, config in pairs(servers) do
    config.capabilities = capabilities
    vim.lsp.config(name, config)
    table.insert(to_enable, name)
  end

  vim.lsp.enable(to_enable)
end

return M
