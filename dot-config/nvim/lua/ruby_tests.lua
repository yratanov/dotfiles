local global_options = {
	cache = {
		last_run = nil,
	},
}

local project_config = require("project_config")
local selected_mapping = project_config.get_project_config("development_environment")

local prefix = ""

if selected_mapping == "docker" then
	prefix = "docker-compose exec web env RAILS_ENV=test "
end

local frameworks = {
	{ pattern = "_spec%.rb$", cmd = "bundle exec rspec " },
	{ pattern = "_test%.rb$", cmd = "bundle exec rails test " },
}

local function detect_framework(file)
	for _, fw in ipairs(frameworks) do
		if file:match(fw.pattern) then
			return fw.cmd
		end
	end
	return nil
end

local function run(cmd, file)
	vim.api.nvim_command("wa")
	local terminal_cmd = "! $HOME/.config/nvim/scripts/run_tests.sh  '"
		.. prefix
		.. cmd
		.. file
		.. "' 2"
	vim.api.nvim_command(terminal_cmd)
end

local function run_file()
	local file = vim.fn.expand("%")
	local cmd = detect_framework(file)
	if cmd then
		global_options.cache.last_run = { cmd = cmd, file = file }
		run(cmd, file)
	end
end

local function run_line()
	local file = vim.fn.expand("%")
	local cmd = detect_framework(file)
	if cmd then
		local file_with_line = file .. ":" .. vim.fn.line(".")
		global_options.cache.last_run = { cmd = cmd, file = file_with_line }
		run(cmd, file_with_line)
	end
end

local function run_last()
	if global_options.cache.last_run then
		run(global_options.cache.last_run.cmd, global_options.cache.last_run.file)
	end
end

vim.keymap.set("n", "<leader>te", run_file, { desc = "[TESTS] run test file" })
vim.keymap.set("n", "<leader>tl", run_line, { desc = "[TESTS] run test on line" })
vim.keymap.set("n", "<leader>re", run_last, { desc = "[TESTS] Rerun last test" })
