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
	vim.cmd("wa")
	neotest.run.run()
end, { desc = "[TESTS] Run tests on line" })

vim.keymap.set("n", "<leader>tr", function()
	vim.cmd("wa")
	neotest.run.run_last()
end, { desc = "[TESTS] Rerun" })

vim.keymap.set("n", "<leader>ts", function()
	neotest.summary.toggle()
end, { desc = "[TESTS] Toggle Summary" })

vim.keymap.set("n", "<leader>tt", function()
	vim.cmd("wa")
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "[TESTS] Run all tests in file" })

vim.keymap.set("n", "<leader>td", function()
	neotest.output.open({ enter = true })
end, { desc = "[TESTS] Open test output" })

vim.keymap.set("n", "<leader>to", function()
	neotest.output_panel.toggle()
end, { desc = "[TESTS] toggle test output panel" })
