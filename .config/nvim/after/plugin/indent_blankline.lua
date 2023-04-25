vim.cmd([[highlight IndentBlanklineIndent1 guifg=#0c3c3c gui=nocombine]])

require("indent_blankline").setup({
	char_highlight_list = {
		"IndentBlanklineIndent1",
	},
	space_char_highlight_list = {
		"IndentBlanklineIndent1",
	},
})
