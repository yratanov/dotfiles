vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Theme
	-- use({ "rose-pine/neovim", as = "rose-pine" })
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("nvim-tree/nvim-web-devicons")
	use("NvChad/nvim-colorizer.lua") -- CSS color highlight

	-- Fuzzy search
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.x",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "otavioschwanck/telescope-alternate" }) -- Alternate files
	use("nvim-telescope/telescope-live-grep-args.nvim")
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	-- File browser
	use({
		"nvim-telescope/telescope-file-browser.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	})

	-- Code highlight
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	-- use("nvim-treesitter/nvim-treesitter-context")
	use("nvim-treesitter/nvim-treesitter-textobjects")
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
	-- use("glepnir/lspsaga.nvim")

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

	-- Utils
	use("mg979/vim-visual-multi")
	use({
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-j>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
			})
		end,
	})

	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})

	-- Test runner
	-- use("klen/nvim-test")
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

	-- adds open in browser functionality
	use("tpope/vim-rhubarb")

	use("rcarriga/nvim-notify")
	use("lukas-reineke/indent-blankline.nvim")
	-- use("xiyaowong/transparent.nvim")

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
	-- use("m4xshen/autoclose.nvim")
	-- require("autoclose").setup()

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

	-- use("f-person/auto-dark-mode.nvim")

	use("tpope/vim-dotenv")

	-- SQL GUI client
	use("tpope/vim-dadbod")
	use("kristijanhusak/vim-dadbod-ui")

	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	-- use({
	-- 	"rmagatti/auto-session",
	-- 	requires = {
	-- 		{ "nvim-telescope/telescope.nvim" },
	-- 	},
	-- 	config = function()
	-- 		require("auto-session").setup({
	-- 			log_level = "error",
	-- 			auto_session_suppress_dirs = { "~/", "~/projects", "~/Downloads", "/" },
	-- 		})
	-- 	end,
	-- })

	use({
		"AckslD/nvim-neoclip.lua",
	})

	use({ "stevearc/dressing.nvim" })

	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})
end)
