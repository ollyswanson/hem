local read_query = function(filename)
  return table.concat(vim.fn.readfile(vim.fn.expand(filename)))
end

require("nvim-treesitter.configs").setup({
  autotag = {
    enable = true,
  },
  ensure_installed = {},
  highlight = {
    enable = true,
    queries = {
      --           rust = read_query("~/.config/nvim/queries/rust/highlights.scm")
    },
  },
  indent = { enable = true, disable = { "rust" } },
  incremental_selection = { enable = true },
  refactor = {
    highlight_definitions = { enable = true },
    smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
      goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
      goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
      goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
    },
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = { ["<leader>kf"] = "@function.outer", ["<leader>kc"] = "@class.outer" },
    },
  },
})
