return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "tpope/vim-rhubarb", event = "VeryLazy" }, -- Open in GitHub
	{ "stevearc/dressing.nvim", event = "VeryLazy" }, -- better popup lists
	"mg979/vim-visual-multi",
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
}
