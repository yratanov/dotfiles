return {
	{
		"LintaoAmons/scratch.nvim",
		event = "VeryLazy",
		init = function()
			vim.keymap.set("n", "<leader>sco", "<cmd>ScratchOpen<CR>", { desc = "[Scratch] Open file" })
			vim.keymap.set("n", "<leader>scn", "<cmd>ScratchWithName<CR>", { desc = "[Scratch] New file" })
			vim.keymap.set("n", "<leader>scf", "<cmd>ScratchOpenFzf<CR>", { desc = "[Scratch] New file" })
		end,
	}, -- save sinppets of code :Scratch
}
