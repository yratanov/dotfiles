local auto_dark_mode = require("auto-dark-mode")

auto_dark_mode.setup({
	update_interval = 1000,
	set_dark_mode = function()
		ColorMyPencils("rose-pine", "main")
		vim.cmd([[highlight IndentBlanklineIndent1 guifg=#0c3c3c gui=nocombine]])
	end,
	set_light_mode = function()
		ColorMyPencils("rose-pine", "dawn")
		vim.cmd([[highlight IndentBlanklineIndent1 guifg=#F2E9E1 gui=nocombine]])
	end,
})

auto_dark_mode.init()
