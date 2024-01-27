return {
	{ "nvim-tree/nvim-web-devicons" },
	{ "mg979/vim-visual-multi" },
	{ "NvChad/nvim-colorizer.lua" }, -- CSS color highlight
	{
		"kylechui/nvim-surround",
		version = "*",
		init = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		init = function()
			require("Comment").setup()
		end,
	},
	{ "LintaoAmons/scratch.nvim", event = "VeryLazy" },
	{ "tpope/vim-rhubarb" }, -- Open in GitHub
	{
		"lukas-reineke/indent-blankline.nvim",
		init = function()
			require("ibl").setup()
		end,
	},
	{
		"max397574/better-escape.nvim",
		init = function()
			require("better_escape").setup({
				mapping = { "jk", "jj" }, -- a table with mappings to use
				timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
				clear_empty_lines = false, -- clear line after escaping if there is only whitespace
				keys = "<Esc>",
			})
		end,
	},
	{
		"folke/which-key.nvim",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
	{ "stevearc/dressing.nvim" }, -- better popup lists
}
