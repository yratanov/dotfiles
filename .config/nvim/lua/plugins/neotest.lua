return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"olimorris/neotest-rspec",
		},

		init = function()
			local neotest = require("neotest")

			neotest.setup({
				adapters = {
					require("neotest-rspec")({}),
				},
				summary = {
					open = "botright vsplit | vertical resize 75",
				},
			})

			vim.keymap.set("n", "<leader>tl", function()
				vim.cmd("wa")
				neotest.run.run()
			end, { desc = "[TESTS] Run tests on line" })

			vim.keymap.set("n", "<leader>re", function()
				vim.cmd("wa")
				neotest.run.run_last()
			end, { desc = "[TESTS] Rerun" })

			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { desc = "[TESTS] Toggle Summary" })

			vim.keymap.set("n", "<leader>te", function()
				vim.cmd("wa")
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "[TESTS] Run all tests in file" })

			vim.keymap.set("n", "<leader>td", function()
				neotest.output.open({ enter = true })
			end, { desc = "[TESTS] Open test output" })

			vim.keymap.set("n", "<leader>to", function()
				neotest.output_panel.toggle()
			end, { desc = "[TESTS] toggle test output panel" })
		end,
	},
}
