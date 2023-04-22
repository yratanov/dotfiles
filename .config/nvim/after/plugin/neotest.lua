local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-rspec")({
			rspec_cmd = function()
				return vim.tbl_flatten({
					"bundle",
					"exec",
					"spring",
					"rspec",
				})
			end,
		}),
	},
})

vim.keymap.set("n", "<leader>tl", function()
	neotest.run.run()
end, { desc = "[TESTS] Run tests on line" })

vim.keymap.set("n", "<leader>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "[TESTS] Run all tests in file" })

vim.keymap.set("n", "<leader>td", function()
	neotest.output.open({ enter = true })
end, { desc = "[TESTS] Open test output" })

vim.keymap.set("n", "<leader>to", function()
	neotest.output_panel.open()
end, { desc = "[TESTS] Open test output panel" })
