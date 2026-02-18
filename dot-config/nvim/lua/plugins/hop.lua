return {
	{
		"phaazon/hop.nvim",
		keys = {
			{ "<Leader>j", function() require("hop").hint_words() end, desc = "[HOP] Jump to word" },
		},
		config = function()
			require("hop").setup({})
		end,
	},
}
