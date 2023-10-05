require("refactoring").setup({})

vim.keymap.set({ "n", "x" }, "<leader>rf", function()
	require("refactoring").select_refactor()
end, { desc = "[REFACTORING] Refactoring menu" })
