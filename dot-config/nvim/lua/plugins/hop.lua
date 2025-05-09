return {
	{
		"phaazon/hop.nvim",
		init = function()
			local hop = require("hop")
			hop.setup({})

			vim.keymap.set("n", "<Leader>j", function()
				hop.hint_words()
			end)
		end,
	},
}
