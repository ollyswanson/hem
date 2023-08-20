local M = {}

function M.setup()
  require("filetype").setup({
    overrides = {
      literal = {
        Justfile = "make",
        justfile = "make"
      }
    }
  })
end

return M
