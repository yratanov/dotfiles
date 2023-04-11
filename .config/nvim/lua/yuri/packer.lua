vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Theme
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use 'nvim-tree/nvim-web-devicons'
  vim.cmd('colorscheme rose-pine')
  use('NvChad/nvim-colorizer.lua') -- CSS color highlight

  -- Fuzzy search
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { "otavioschwanck/telescope-alternate" } -- Alternate files

  -- File browser
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }

  -- Code highlight
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'windwp/nvim-ts-autotag' -- Automatically close tags
  use 'RRethy/nvim-treesitter-endwise' -- Automatically close blocks

  -- Local History
  use('mbbill/undotree')
  use('theprimeagen/harpoon')

  -- Git
  use('tpope/vim-fugitive')
  use { 'lewis6991/gitsigns.nvim' }

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      { 'neovim/nvim-lspconfig' }, -- Required
      {
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
    }
  }
  use 'glepnir/lspsaga.nvim'

  use 'antosha417/nvim-lsp-file-operations'
  use 'onsails/lspkind-nvim'

  -- Code snippets
  use({
    "L3MON4D3/LuaSnip",
    tag = "v<CurrentMajor>.*",
    run = "make install_jsregexp"
  })
  use { 'saadparwaiz1/cmp_luasnip' }
  use 'rafamadriz/friendly-snippets'

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Code formatter
  use('jose-elias-alvarez/null-ls.nvim')
  use('MunifTanjim/prettier.nvim')

  -- Tabs
  -- use { 'romgrk/barbar.nvim', requires = 'nvim-web-devicons' }

  use 'mg979/vim-visual-multi'
  use 'github/copilot.vim'
  use 'tpope/vim-surround'

  -- Test runner
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      'olimorris/neotest-rspec'
    }
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  use {
    "LintaoAmons/scratch.nvim",
    tag= "v0.6.2"
  }
end)
