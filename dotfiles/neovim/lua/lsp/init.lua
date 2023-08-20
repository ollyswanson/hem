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

function M.make_on_attach(lang_on_attach)
  return function(client, bufnr)
    require("mappings").lsp_mappings(client, bufnr)
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
