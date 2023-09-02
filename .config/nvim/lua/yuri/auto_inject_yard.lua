vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.rb" },
	callback = function()
		local script = vim.fn.expand("~") .. "/.config/nvim/scripts/dry_auto_inject_to_yard.rb"
		local file_path = vim.fn.expand("%:p")
		local inflections = vim.fn.getcwd() .. "/config/initializers/inflections.rb"
		local deps = "PulseAPI::Deps"

		vim.cmd("silent !" .. script .. " " .. file_path .. " " .. deps .. " " .. inflections)
	end,
	desc = "Auto inject yard doc",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.erb" },
	callback = function()
		local file_path = vim.fn.expand("%:p")

		vim.cmd("silent !" .. "/Users/yuri/.rbenv/shims/erb-format" .. " " .. file_path .. " --write")
	end,
	desc = "Auto format erb files",
})
