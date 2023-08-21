return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>g"] = { name = "git" },
        ["<leader>t"] = { name = "telescope" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      local current_buffer_fuzzy_find = function()
        builtin.current_buffer_fuzzy_find({
          layout_strategy = "vertical",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
        })
      end

      local git_branches = function()
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

      telescope.setup({
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

      local map = vim.keymap.set

      map("n", "<C-p>", builtin.find_files, { desc = "find files" })
      map("n", "<leader>lg", builtin.live_grep, { desc = "live grep" })
      map("n", "<leader>lf", current_buffer_fuzzy_find, { desc = "find in buffer" })
      map("n", "<leader>th", builtin.help_tags, { desc = "help tags" })
      map("n", "<leader>tr", builtin.lsp_references, { desc = "lsp references" })
      map("n", "<leader>tb", builtin.buffers, { desc = "show buffers" })
      map("n", "<leader>tg", builtin.grep_string, { desc = "grep string" })
      map("n", "<leader>td", builtin.diagnostics, { desc = "workspace diagnostics" })
      map("n", "<leader>tt", builtin.resume, { desc = "resume" })
      map("n", "<leader>tk", builtin.keymaps, { desc = "keymaps" })
      map("n", "<leader>tj", builtin.registers, { desc = "registers" })
      map("n", "<leader>ts", builtin.treesitter, { desc = "treesitter" })
      map("n", "<leader>tc", builtin.command_history, { desc = "command history" })
      map("n", "<leader>tm", builtin.marks, { desc = "marks" })

      map("n", "<leader>gb", git_branches, { desc = "branches" })
      map("n", "<leader>gc", builtin.git_commits, { desc = "commits" })
      map("n", "<leader>gj", builtin.git_bcommits, { desc = "bcommits" })
      map("n", "<leader>gs", builtin.git_status, { desc = "status" })
      map("n", "<leader>gg", "<cmd> Git<CR>", { desc = "fugitive" })
    end,

  }
}
