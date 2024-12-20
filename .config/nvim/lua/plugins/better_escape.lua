return {
	{
		"max397574/better-escape.nvim",
		init = function()
			require("better_escape").setup({
				timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
				clear_empty_lines = false, -- clear line after escaping if there is only whitespace
				keys = "<Esc>",
				default_mappings = false,
				mappings = {
					i = {
						j = {
							k = "<Esc>",
							j = "<Esc>",
						},
					},
				},
			})
		end,
	},
}
