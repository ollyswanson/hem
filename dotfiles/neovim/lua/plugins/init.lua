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

  "neovim/nvim-lspconfig",
  -- TODO: Might want to use Nix instead
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          check_outdated_servers_on_open = true,
          icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
          }
        }
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {},
      })
    end
  },
  -- TODO: Deprecated
  "jose-elias-alvarez/null-ls.nvim",
  -- TODO: Why am I using this? Lol
  "stevearc/dressing.nvim",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({ buftype_exclude = { "terminal" }, show_end_of_line = true })
    end,
  },
  -- use {
  --   'TimUntersberger/neogit',
  --   dependencies = {'sindrets/diffview.nvim'},
  --   config = function()
  --     vim.defer_fn(function()
  --       require('neogit').init {integrations = {diffview = true}}
  --     end, 10)
  --   end
  -- }
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
