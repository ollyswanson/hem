return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>h"] = { name = "+gitsigns" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = {
        add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = {
          hl = "GitSignsChange",
          text = "│",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        delete = {
          hl = "GitSignsDelete",
          text = "_",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        topdelete = {
          hl = "GitSignsDelete",
          text = "‾",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "~",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = { interval = 1000, follow_files = true },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
      },
      current_line_blame_formatter_opts = { relative_time = false },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      yadm = { enable = false },
    },
    config = function(_, opts)
      local map = vim.keymap.set

      map("n", "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "stage hunk" })
      map("n", "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, { desc = "undo stage hunk" })
      map("n", "<leader>hr", function() require("gitsigns").reset_hunk() end, { desc = "reset hunk" })
      map("n", "<leader>hR", function() require("gitsigns").reset_buffer() end, { desc = "reset buffer" })
      map("n", "<leader>hp", function() require("gitsigns").preview_hunk() end, { desc = "preview hunk" })
      map("n", "<leader>hb", function() require("gitsigns").blame_line() end, { desc = "blame line" })
      map("n", "<leader>hS", function() require("gitsigns").stage_buffer() end, { desc = "stage buffer" })
      map("n", "<leader>hU", function() require("gitsigns").reset_buffer_index() end, { desc = "reset buffer index" })

      map(
        "v",
        "<leader>hs",
        function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        { desc = "stage hunk" }
      )
      map(
        "v",
        "<leader>hr",
        function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        { desc = "reset hunk" }
      )


      require("gitsigns").setup(opts)
    end,
  }
}
