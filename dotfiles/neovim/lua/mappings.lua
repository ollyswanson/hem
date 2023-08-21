local M = {}

local map = require("utils").new_map
local wk = require("which-key").register

function M.define_mappings()
  map("n", "<C-j>", "<Esc>")
  map("i", "<C-j>", "<Esc>")
  map("v", "<C-j>", "<Esc>")
  map("s", "<C-j>", "<Esc>")
  map("x", "<C-j>", "<Esc>")
  map("c", "<C-j>", "<Esc>")
  map("o", "<C-j>", "<Esc>")
  map("l", "<C-j>", "<Esc>")
  map("t", "<C-j>", "<C-\\><C-n>")

  map("n", "<C-k>", "<Esc>")
  map("i", "<C-k>", "<Esc>")
  map("v", "<C-k>", "<Esc>")
  map("s", "<C-k>", "<Esc>")
  map("x", "<C-k>", "<Esc>")
  map("c", "<C-k>", "<Esc>")
  map("o", "<C-k>", "<Esc>")
  map("l", "<C-k>", "<Esc>")
  map("t", "<C-k>", "<Esc>")

  map("n", "<leader>e", ':e <C-R>=expand("%:p:h") . "/" <CR>')
  map("n", "sw", ":%s/<C-R><C-W>//g<left><left>")
  map("n", "<leader><leader>", ":noh<CR>")

  map("n", "<C-h>", "<C-w>h")
  map("n", "<C-j>", "<C-w>j")
  map("n", "<C-k>", "<C-w>k")
  map("n", "<C-l>", "<C-w>l")

  map("n", "H", "0")
  map("n", "L", "$")
  map("o", "H", "0")
  map("o", "L", "$")

  wk({
    ["<leader>q"] = {
      name = "quit",
      q = { "<cmd> lua require('funcs').close_everything()<CR>", "all" },
      w = { "<cmd> q<CR>", "w" },
    },
    ["<leader>n"] = {
      name = "file tree",
      n = { "<cmd> NvimTreeToggle<CR>", "toggle" },
      h = { "<cmd> NvimTreeFindFile<CR>", "open here" },
    },
    ["<leader>T"] = { "<cmd>terminal<CR>", "terminal" },
  })
end

function M.cmp_mappings()
end

function M.lsp_mappings(client, bufnr)
  local function buf_map(mode, lhs, rhs)
    require("utils").buf_map(bufnr, mode, lhs, rhs)
  end

  buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  buf_map("i", "<C-g>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  buf_map("v", "<leader>la", ":<C-U>lua require('mappings').range_code_action()<CR>")

  wk({
    g = {
      name = "goto",
      d = { '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', "definition" },
      D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "declaration" },
      i = { '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', "implementation" },
      r = { '<cmd>lua require("telescope.builtin").lsp_references()<CR>', "references" },
      t = { '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>', "type" },
    },
    ["<leader>f"] = {
      s = { "<cmd>Telescope lsp_document_symbols<CR>", "document symbols" },
      S = { "<cmd>Telescope lsp_workspace_symbols<CR>", "workspace symbols" },
      r = { "<cmd>Telescope lsp_references<CR>", "references" },
    },
    ["<leader>w"] = {
      name = "workspace",
      a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "add folder" },
      r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "remove folder" },
      l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "list folders" },
    },
    ["<leader>D"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "show type definition" },
    ["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "rename" },
    d = {
      name = "diagnostics",
      l = { "<cmd>lua vim.diagnostic.open_float()<CR>", "show line" },
      n = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "next" },
      p = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "prev" },
    },
    ["<leader>l"] = {
      name = "lsp",
      -- a = { "<cmd>Telescope lsp_code_actions<CR>", "code actions" },
      a = { "<cmd> lua vim.lsp.buf.code_action()<CR>", "code actions" },
    },
    ["<leader>x"] = {
      name = "trouble",
      x = { "<cmd>Trouble<CR>", "open" },
      w = { "<cmd>Trouble workspace_diagnostics<CR>", "workspace" },
      d = { "<cmd> Trouble document_diagnostics<CR>", "document" },
    },
    ["<leader>t"] = {
      name = "telecscope",
      w = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", "workspace symbol" },
    }
  }, {
    buffer = bufnr,
  })

  if client.server_capabilities.document_formatting then
    buf_map("n", "<leader>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  end
end

function M.range_code_action()
  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  vim.lsp.buf.range_code_action({}, start_pos, end_pos)
end

function M.dap_mappings(bufnr)
  wk({
    ["<leader>b"] = {
      ["<space>"] = { '<cmd>lua require("dap").repl.toggle()<CR>', "toggle repl" },
      b = { '<cmd>lua require("dap").toggle_breakpoint()<CR>', "breakpoint" },
      c = { '<cmd>lua require("dap").continue()<CR>', "continue" },
      i = { '<cmd>lua require("dap").step_into()<CR>', "step into" },
      l = { '<cmd>lua require("dap").run_last()<CR>', "run last" },
      o = { '<cmd>lua require("dap").step_over()<CR>', "step over" },
      x = { '<cmd>lua require("dap").step_out()<CR>', "step out" },
      v = { '<cmd>lua require("dap.ui.variables").hover()<CR>', "debug value" },
    },
  }, {
    buffer = bufnr,
  })

  wk({
    ["<leader>b"] = {
      name = "show",
      v = { '<cmd>lua require("dap.ui.variables").visual_hover()<CR>', "debug value" },
    },
  }, {
    buffer = bufnr,
    mode = "v",
  })
end

function M.c_mappings(bufnr)
  wk({
    ["<leader>c"] = {
      name = "c",
      h = { "<cmd> ClangdSwitchSourceHeader<CR>", "switch header" },
    }
  })
end

return M
