local global_options = {
	cache = {
		last_run = nil,
	},
}

-- file = vim.fn.expand('%')
-- line = vim.fn.line('.')
local function run(command)
	local terminal_cmd = "!tmux send -t 2 'bundle exec rspec " .. command .. "' Enter"
	vim.api.nvim_command("!tmux send -t 2 -X cancel")
	vim.api.nvim_command(terminal_cmd)
end

local function run_file()
	local command = vim.fn.expand("%")
	global_options.cache.last_run = command
	run(command)
end

local function run_line()
	local command = vim.fn.expand("%") .. ":" .. vim.fn.line(".")
	global_options.cache.last_run = command
	run(command)
end

local function run_last()
	run(global_options.cache.last_run)
end

vim.keymap.set("n", "<leader>te", run_file, { desc = "[TESTS] run spec file" })
vim.keymap.set("n", "<leader>tl", run_line, { desc = "[TESTS] run spec on line" })
vim.keymap.set("n", "<leader>re", run_last, { desc = "[TESTS] Rerun last spec" })
