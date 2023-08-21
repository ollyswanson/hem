-- Used for getting status reports from the LSP client.
-- Can be used to display context of where the cursor is and diagnostics from the current buffer.

local nvim_status = require("lsp-status")
local messages = require("lsp-status/messaging").messages

local symbols = {
  status_symbol = "☢",
  indicator_errors = "",
  indicator_warnings = "",
  indicator_info = "🛈",
  indicator_hint = "!",
  indicator_ok = "",
  spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
}

local status = {}

status.select_symbol = function(cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ["start"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[1]) },
      ["end"] = { character = 0, line = vim.fn.byte2line(symbol.valueRange[2]) },
    }

    return require("lsp-status.util").in_range(cursor_pos, value_range)
  end
end

status.activate = function()
  nvim_status.config(symbols)

  nvim_status.register_progress()
end

status.on_attach = function(client)
  nvim_status.on_attach(client)

  -- TODO: I'm not using this anywhere, so commenting out for now
  -- vim.api.nvim_create_autocmd('CursorHold,BufEnter', {
  --   -- TODO: Review where the augroup should be made
  --   group = vim.api.nvim_create_augroup('og_lsp_status', { clear = true }),
  --   desc = 'LSP Status',
  --   pattern = '*',
  --   callback = function()
  --     if client.server_capabilities.documentSymbolProvider then
  --       require("lsp-status").update_current_function()
  --       nvim_status.update_current_function()
  --     end
  --   end
  -- })
end

-- Used by language servers such as rust-analyzer to report progress when indexing project.
status.progress_message = function()
  local buf_messages = messages()
  local msgs = {}
  for _, msg in ipairs(buf_messages) do
    local name = msg.name
    local client_name = "[" .. name .. "]"
    local contents = ""
    if msg.progress then
      contents = msg.title
      if msg.message then
        contents = contents .. " " .. msg.message
      end

      if msg.percentage then
        contents = contents .. " (" .. msg.percentage .. ")"
      end

      if msg.spinner then
        contents = symbols.spinner_frames[(msg.spinner % #symbols.spinner_frames) + 1] .. " " .. contents
      end
    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ":~:.")
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        contents = "(" .. filename .. ") " .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. " " .. contents)
  end

  return vim.trim(table.concat(msgs, ""))
end

return status
