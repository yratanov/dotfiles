return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "tpope/vim-rhubarb", event = "VeryLazy" }, -- Open in GitHub
	{ "stevearc/dressing.nvim", event = "VeryLazy" }, -- better popup lists
	{
		"mg979/vim-visual-multi",
		lazy = false,
		init = function()
			vim.g.VM_maps = {
				["I BS"] = "",
			}
		end,
	},
	{ "kylechui/nvim-surround", config = true },
	{ "numToStr/Comment.nvim", config = true },
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		requires = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"nvim-pack/nvim-spectre",
		init = function()
			vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
		end,
	},
}
