local M = {}

require("lsp.settings")

function M.make_common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  capabilities.workspace.configuration = true

  local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_status_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local lsp_status_ok, lsp_status = pcall(require, "lsp-status")
  if lsp_status_ok then
    capabilities = vim.tbl_deep_extend("keep", capabilities, lsp_status.capabilities)
  end

  return capabilities
end

local range_code_action = function()
  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  vim.lsp.buf.range_code_action({}, start_pos, end_pos)
end

function M.make_on_attach(lang_on_attach)
  return function(client, bufnr)
    local map = vim.keymap.set
    local builtin = require("telescope.builtin")

    map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, })
    map("i", "<C-g>", vim.lsp.buf.signature_help, { buffer = bufnr })
    map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code actions" })
    map("v", "<leader>la", range_code_action, { buffer = bufnr })

    map("n", "gd", builtin.lsp_definitions, { buffer = bufnr, desc = "definition" })
    map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "declaration" })
    map("n", "gi", builtin.lsp_implementations, { buffer = bufnr, desc = "implementation" })
    map("n", "gr", builtin.lsp_references, { buffer = bufnr, desc = "implementation" })
    map("n", "gt", builtin.lsp_type_definitions, { buffer = bufnr, desc = "type" })
    map("n", "<leader>fs", builtin.lsp_document_symbols, { buffer = bufnr, desc = "document symbols" })
    --TODO: This is a duplicate :)
    map("n", "<leader>fw", builtin.lsp_workspace_symbols, { buffer = bufnr, desc = "workspace symbols" })

    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "add folder" })
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "remove folder" })
    map(
      "n",
      "<leader>wr",
      function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      { buffer = bufnr, desc = "remove folder" }
    )

    map("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "show type definition" })
    map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "show type definition" })

    map("n", "dl", vim.diagnostic.open_float, { buffer = bufnr, desc = "show line" })
    map("n", "dn", vim.diagnostic.goto_next, { buffer = bufnr, desc = "next" })
    map("n", "dp", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "prev" })

    map("n", "<leader>xx", "<cmd> Trouble<CR>", { buffer = bufnr, desc = "open" })
    map("n", "<leader>xw", "<cmd> Trouble workspace_diagnostice<CR>", { buffer = bufnr, desc = "workspace" })
    map("n", "<leader>xd", "<cmd> Trouble document_diagnostics<CR>", { buffer = bufnr, desc = "workspace" })

    if client.supports_method("documentFormattingProvider") then
      map("n", "<leader>ff", vim.lsp.buf.format, { buffer = bufnr, desc = "formatting" })
    end

    require("lsp.status").on_attach(client)
    if lang_on_attach ~= nil then
      lang_on_attach(client, bufnr)
    end
  end
end

-- TODO: Make sure that this is called for each language.
function M.setup_server(lang)
  local lsp = olsp.lang[lang].lsp

  if lsp.provider ~= nil and lsp.provider ~= "" then
    local lspconfig = require("lspconfig")

    lsp.setup.on_attach = M.make_on_attach(lsp.lang_on_attach)

    if not lsp.setup.capabilities then
      lsp.setup.capabilities = M.make_common_capabilities()
    end

    lspconfig[lsp.provider].setup(lsp.setup or {})
  end
end

function M.setup()
  vim.lsp.protocol.CompletionItemKind = olsp.completion.item_kind

  -- set symbols for diagnostics
  for _, sign in ipairs(olsp.diagnostics.signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  -- set handlers
  require("lsp.handlers").setup()

  -- set status bar (server progress and errors in status line)
  require("lsp.status").activate()

  require("lsp.null-ls").setup()

  for lang, _ in pairs(olsp.lang) do
    M.setup_server(lang)
  end
end

return M
