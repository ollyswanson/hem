return {
  "folke/which-key.nvim",
  opts = {
    plugins = {
      marks = true,       -- shows a list of your marks on ' and `
      registers = true,   -- shows your registers on " in normal or <c-r> in insert mode
      spelling = {
        enabled = false,  -- enabling this will show whichkey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      presets = {
        operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
        motions = true,      -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true,      -- default bindings on <c-w>
        nav = true,          -- misc bindings to work with windows
        z = true,            -- bindings for folds, spelling and others prefixed with z
        g = true,            -- bindings for prefixed with g
      },
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3,                    -- spacing between columns
      align = "left",                 -- align columns left, center or right
    },
    show_help = true,                 -- show help message on the command line when the popup is visible
    triggers = {
      { "<leader>", mode = { "n", "v" } },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")

    -- Register all prefix names here. It doesn't seem to work when done with plugins :/
    wk.setup(opts)
    wk.add({
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "hunk" },
      { "<leader>l", group = "grep +lsp" },
      { "<leader>n", group = "tree" },
      { "<leader>q", group = "quit" },
      { "<leader>r", group = "rename +rust" },
      { "<leader>t", group = "telescope" },
      { "<leader>w", group = "workspace" },
      { "<leader>x", group = "trouble" },
      { "d",         group = "diagnostics" },
      { "g",         group = "goto" },
    })
  end
}
