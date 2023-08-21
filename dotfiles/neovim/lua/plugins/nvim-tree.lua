return {
  "kyazdani42/nvim-tree.lua",
  dependencies = "kyazdani42/nvim-web-devicons",
  opts = {
    disable_netrw = false,
    hijack_netrw = true,
  },
  config = function(_, opts)
    local map = vim.keymap.set
    map("n", "<leader>nn", "<cmd> NvimTreeToggle<CR>", { desc = "toggle" })
    map("n", "<leader>nh", "<cmd> NvimTreeFindFile<CR>", { desc = "open here" })
    require("nvim-tree").setup(opts)
  end
}
