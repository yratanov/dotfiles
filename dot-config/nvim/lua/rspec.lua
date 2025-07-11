local global_options = {
	cache = {
		last_run = nil,
	},
}

local project_config = require("project_config")
local selected_mapping = project_config.get_project_config("development_environment")

local prefix = ""

if selected_mapping == "docker" then
	prefix = "docker-compose exec web "
end

local function run(file)
	vim.api.nvim_command("wa")
	local terminal_cmd = "! $HOME/.config/nvim/scripts/run_tests.sh  '"
		.. prefix
		.. "bundle exec rspec "
		.. file
		.. "' 2"
	vim.api.nvim_command(terminal_cmd)
end

local function run_file()
	local file = vim.fn.expand("%")
	if file:sub(-8) == "_spec.rb" then
		global_options.cache.last_run = file
		run(file)
	end
end

local function run_line()
	local file = vim.fn.expand("%")
	if file:sub(-8) == "_spec.rb" then
		file = file .. ":" .. vim.fn.line(".")
		global_options.cache.last_run = file
		run(file)
	end
end

local function run_last()
	if global_options.cache.last_run then
		run(global_options.cache.last_run)
	end
end

vim.keymap.set("n", "<leader>te", run_file, { desc = "[TESTS] run spec file" })
vim.keymap.set("n", "<leader>tl", run_line, { desc = "[TESTS] run spec on line" })
vim.keymap.set("n", "<leader>re", run_last, { desc = "[TESTS] Rerun last spec" })
