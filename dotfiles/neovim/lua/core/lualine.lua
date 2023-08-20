local M = {}

vim.cmd("colorscheme nordfox")

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
}

local config = {
  options = {
    theme = "nightfox",
    icons_enabled = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "filetype" },
  },
}

-- insert components into left hand side of statusline
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- insert components into right hand side of statusline
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({ "filename", cond = conditions.buffer_not_empty })

ins_left({
  function()
    local msg = "No Active Lsp"
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = " LSP:",
  padding = { left = 1 },
})

ins_left({
  "diagnostics",
  sources = { "nvim_lsp" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    error = 'DiagnosticError',
    warn = 'DiagnosticWarn',
    info = 'DiagnosticInfo',
  },
})

ins_left({
  require("lsp.status").progress_message,
  padding = { left = 1 },
})

ins_right({
  "diff",
  symbols = { added = " ", modified = "柳", removed = " " },
  colored = true,
  cond = conditions.hide_in_width,
  padding = { right = 1 },
})

ins_right({ "encoding", cond = conditions.hide_in_width })

ins_right({ "fileformat", cond = conditions.hide_in_width })

function M.setup()
  return config
end

return M
