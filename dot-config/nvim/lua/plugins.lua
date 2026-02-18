return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "tpope/vim-rhubarb", event = "VeryLazy" }, -- Open in GitHub
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		init = function()
			vim.schedule(function()
				vim.g.VM_maps = {
					["I BS"] = "",
					["Goto Next"] = "",
					["Goto Prev"] = "",
				}
			end)
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
		opts = {},
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-pack/nvim-spectre",
		keys = {
			{ "<leader>S", function() require("spectre").toggle() end, desc = "[SPECTRE] Toggle search/replace" },
		},
		opts = {},
	},
}
