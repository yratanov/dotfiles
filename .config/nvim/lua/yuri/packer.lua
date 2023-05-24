vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Theme
	use({ "rose-pine/neovim", as = "rose-pine" })
	use("nvim-tree/nvim-web-devicons")
	use("NvChad/nvim-colorizer.lua") -- CSS color highlight

	-- Fuzzy search
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "otavioschwanck/telescope-alternate" }) -- Alternate files
	use("nvim-telescope/telescope-live-grep-args.nvim")

	-- File browser
	use({
		"nvim-telescope/telescope-file-browser.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	})

	-- Code highlight
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-context")
	use("windwp/nvim-ts-autotag") -- Automatically close tags
	use("RRethy/nvim-treesitter-endwise") -- Automatically close blocks

	-- Local History
	use("mbbill/undotree")
	use("theprimeagen/harpoon")

	-- Git
	use("tpope/vim-fugitive")
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	use({ "lewis6991/gitsigns.nvim" })

	-- LSP
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		requires = {
			{ "neovim/nvim-lspconfig" }, -- Required
			{
				"williamboman/mason.nvim",
				run = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
		},
	})
	use("glepnir/lspsaga.nvim")

	use("antosha417/nvim-lsp-file-operations")
	use("onsails/lspkind-nvim") -- LSP icons

	-- Code snippets
	use({
		"L3MON4D3/LuaSnip",
		tag = "v<CurrentMajor>.*",
		run = "make install_jsregexp",
	})
	use({ "saadparwaiz1/cmp_luasnip" })
	use("rafamadriz/friendly-snippets")

	-- Status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	-- Code formatter
	use("jose-elias-alvarez/null-ls.nvim")
	use("MunifTanjim/prettier.nvim")
	use({ "ckipp01/stylua-nvim", run = "cargo install stylua" })

	use("mg979/vim-visual-multi")
	use("github/copilot.vim")
	use("tpope/vim-surround")

	-- Test runner
	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"olimorris/neotest-rspec",
		},
	})

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"LintaoAmons/scratch.nvim",
		tag = "v0.6.2",
	})

	use("tpope/vim-rhubarb")

	use("rcarriga/nvim-notify")
	use("lukas-reineke/indent-blankline.nvim")
	use("xiyaowong/transparent.nvim")

	use({
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				mapping = { "jk", "jj" }, -- a table with mappings to use
				timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
				clear_empty_lines = false, -- clear line after escaping if there is only whitespace
				keys = "<Esc>",
			})
		end,
	})

	-- Jump to any word in the current buffer
	use("phaazon/hop.nvim", {
		branch = "v2",
	})

	-- Automatically close brackets
	use("m4xshen/autoclose.nvim")
	require("autoclose").setup()

	use({
		"gbprod/substitute.nvim",
		config = function()
			require("substitute").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
end)
