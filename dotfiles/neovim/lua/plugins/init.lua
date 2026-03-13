return {
  -- If there are any issues with this plugin, try `NightfoxCompile`
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme nordfox")
    end,
  },

  "tpope/vim-surround",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  "sindrets/diffview.nvim",
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end
  },
  "ellisonleao/glow.nvim",
}
