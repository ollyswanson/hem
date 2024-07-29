return
{
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
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
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
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
  },
  config = function(_, opts)
    local map = vim.keymap.set
    local gs = require("gitsigns")

    map("n", "<leader>hs", gs.stage_hunk, { desc = "stage hunk" })
    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
    map("n", "<leader>hr", gs.reset_hunk, { desc = "reset hunk" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "reset buffer" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk" })
    map("n", "<leader>hb", gs.blame_line, { desc = "blame line" })
    map("n", "<leader>hS", gs.stage_buffer, { desc = "stage buffer" })
    map("n", "<leader>hU", gs.reset_buffer_index, { desc = "reset buffer index" })

    map(
      "v",
      "<leader>hs",
      function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
      { desc = "stage hunk" }
    )
    map(
      "v",
      "<leader>hr",
      function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
      { desc = "reset hunk" }
    )


    gs.setup(opts)
  end,
}
