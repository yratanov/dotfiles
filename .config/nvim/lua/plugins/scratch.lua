return {
	{
		"LintaoAmons/scratch.nvim",
		event = "VeryLazy",
		init = function()
			vim.keymap.set("n", "<leader>sco", "<cmd>ScratchOpen<CR>", { desc = "[Scratch] Open file" })
			vim.keymap.set("n", "<leader>scn", "<cmd>ScratchWithName<CR>", { desc = "[Scratch] New file" })
			vim.keymap.set("n", "<leader>scf", "<cmd>ScratchOpenFzf<CR>", { desc = "[Scratch] New file" })
		end,
		config = function()
			require("scratch").setup({
				scratch_file_dir = vim.fn.getcwd() .. "/scratches", -- where your scratch files will be put
				use_telescope = true,
				file_picker = "telescope", -- "fzflua" | "telescope" | nil
				filetypes = { "rb", "js", "sh", "ts" }, -- you can simply put filetype here
			})
		end,
	}, -- save sinppets of code :Scratch
}
