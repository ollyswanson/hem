local M = {}

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local wk = require("which-key").register

function M.setup()
  require("telescope").setup({
    defaults = {
      mappings = {
        i = { ["<CR>"] = actions.select_default + actions.center, ["<C-j>"] = { "<esc>", type = "command" } },
        n = { ["<CR>"] = actions.select_default + actions.center },
      },
      file_ignore_patterns = {
        ".git/*",
        "node_modules/*",
        "bower_components/*",
        ".svn/*",
        ".hg/*",
        "CVS/*",
        ".next/*",
        ".docz/*",
        ".DS_Store",
      },
      layout_strategy = "flex",
      scroll_strategy = "cycle",
    },
  })

  wk({
    ["<C-p>"] = { '<cmd>lua require("telescope.builtin").find_files()<CR>', "find files" },
    ["<leader>l"] = {
      g = { '<cmd>lua require("telescope.builtin").live_grep()<CR>', "show buffers" },
      f = { '<cmd>lua require("core.telescope").current_buffer_fuzzy_find()<CR>', "show buffers" },
    },
    ["<leader>t"] = {
      name = "telescope",
      h = { '<cmd>lua require("telescope.builtin").help_tags()<CR>', "help tags" },
      r = { '<cmd>lua require("telescope.builtin").lsp_references()<CR>', "lsp references" },
      b = { '<cmd>lua require("telescope.builtin").buffers()<CR>', "show buffers" },
      g = { '<cmd>lua require("telescope.builtin").grep_string()<CR>', "show buffers" },
      p = { '<cmd>lua require("telescope.builtin").file_browser()<CR>', "file browser" },
      d = {
        '<cmd>lua require("telescope.builtin").diagnostics()<CR>',
        "workspace diagnostics",
      },
      t = { '<cmd>lua require("telescope.builtin").resume()<CR>', "resume" },
      k = { '<cmd>lua require("telescope.builtin").keymaps()<CR>', "keymaps" },
      j = { '<cmd> lua require("telescope.builtin").registers()<CR>', "registers" },
      s = { '<cmd> lua require("telescope.builtin").treesitter()<CR>', "treesitter" },
      c = { '<cmd> lua require("telescope.builtin").command_history()<CR>', "commands" },
      m = { '<cmd> lua require("telescope.builtin").marks()<CR>', "commands" },
    },
    ["<leader>g"] = {
      name = "git",
      b = { '<cmd> lua require("core.telescope").git_branches()<CR>', "branch" },
      c = { '<cmd> lua require("telescope.builtin").git_commits()<CR>', "commits" },
      j = { '<cmd> lua require("telescope.builtin").git_bcommits()<CR>', "bcommits" },
      s = { '<cmd> lua require("telescope.builtin").git_status()<CR>', "status" },
      g = { "<cmd> Git<CR>", "fugitive" },
    },
  })
end

function M.git_branches()
  builtin.git_branches({
    attach_mappings = function(_, map)
      actions.select_default:replace(actions.git_checkout)
      map("i", "<c-t>", actions.git_track_branch)
      map("n", "<c-t>", actions.git_track_branch)

      map("i", "<c-r>", actions.git_rebase_branch)
      map("n", "<c-r>", actions.git_rebase_branch)

      map("i", "<c-h>", actions.git_create_branch)
      map("n", "<c-h>", actions.git_create_branch)

      map("i", "<c-s>", actions.git_switch_branch)
      map("n", "<c-s>", actions.git_switch_branch)

      map("i", "<c-d>", actions.git_delete_branch)
      map("n", "<c-d>", actions.git_delete_branch)
      return true
    end,
  })
end

function M.current_buffer_fuzzy_find()
  builtin.current_buffer_fuzzy_find({
    layout_strategy = "vertical",
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending",
  })
end

return M
