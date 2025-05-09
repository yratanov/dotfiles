return {
	{
		"tpope/vim-fugitive",
		init = function()
			vim.keymap.set("n", "<leader>gg", vim.cmd.Git, { desc = "[GIT] Git status" })
			vim.keymap.set("n", "<leader>gp", ":Git push<Cr>", { desc = "[GIT] Git push" })
			vim.keymap.set("n", "<leader>gc", ":Git checkout", { desc = "[GIT] Git checkout" })
			vim.keymap.set("n", "<leader>go", ":.GBrowse<CR>", { desc = "[GIT] Open on Github" })
			vim.keymap.set("n", "<leader>gt", ":Git pull<CR>", { desc = "[GIT] Git pull" })
		end,
	},
}
