local builtin = require("telescope.builtin")
local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = "close",
				["<C-c>"] = false,
			},
		},
	},
})
telescope.load_extension("live_grep_args")
local telescope_live_grep_args = require("telescope").extensions.live_grep_args

local function dasherize(str)
	return (string.gsub(str, "%W+", "-"))
end

local function decamelize(str)
	return string.lower((string.gsub(str, "(%l)(%u)", "%1_%2")))
end

local function singularize(name)
	local irregulars = {}
	local out = name:gsub("(%w+)$", irregulars)
	if out ~= name then
		return out
	end
	out = name:gsub("[iI][eE]([sS])$", {
		s = "y",
		S = "Y",
	}):gsub("([oO])[eE][sS]$", "%1")
	if out:sub(-4, -1) == "sses" then
		out = out:gsub("([sS][sS])[eE][sS]$", "%1")
	else
		out = out:gsub("[sS]$", "")
	end
	return out
end

vim.keymap.set("n", "<leader>o", function()
	builtin.find_files({ hidden = true })
end, { desc = "[TELESCOPE] Find files" })

vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[TELESCOPE] Grep current word" })
vim.keymap.set("n", "<leader>f/", builtin.current_buffer_fuzzy_find, { desc = "[TELESCOPE] Find current buffer" })
vim.keymap.set("n", "<leader>fi", builtin.search_history, { desc = "[TELESCOPE] Search history" })

vim.keymap.set("n", "<leader>ff", telescope_live_grep_args.live_grep_args, { desc = "[TELESCOPE] Grep" })
vim.keymap.set("n", "<leader>s", builtin.live_grep, { desc = "[TELESCOPE] Grep" })

vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[TELESCOPE] Keymaps" })

vim.keymap.set("n", "<leader>e", function()
	builtin.oldfiles({ only_cwd = true })
end, { desc = "[TELESCOPE] Prev files" })

vim.keymap.set("n", "<leader>b", builtin.git_branches, { desc = "[TELESCOPE] Git branches" })

vim.keymap.set("n", "<leader>fs", builtin.git_stash, { desc = "[TELESCOPE] Git stashes" })

vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "[TELESCOPE] LSP references" })

vim.keymap.set("n", "<leader>gm", function()
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.api.nvim_buf_get_option(buf, "filetype")
	if ft == "ruby" then
		local filepath = "app/models/" .. singularize(vim.fn.expand("<cword>")) .. ".rb"
		if vim.fn.filereadable(filepath) == 1 then
			vim.cmd(":e " .. filepath)
		end
	elseif ft == "typescript" or ft == "javascript" then
		local filepath = "app/models/" .. dasherize(decamelize(singularize(vim.fn.expand("<cword>")))) .. ".ts"
		if vim.fn.filereadable(filepath) == 1 then
			vim.cmd(":e " .. filepath)
		end
	end
end, { desc = "[TELESCOPE] Open model file" })

vim.keymap.set("n", "<leader>fc", function()
	builtin.find_files({ search_file = dasherize(decamelize(vim.fn.expand("<cword>"))) })
end, { desc = "[TELESCOPE] Find file by current word" })

vim.keymap.set("n", "<leader>gf", function()
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.api.nvim_buf_get_option(buf, "filetype")
	if ft == "ruby" then
		local filepath = "spec/factories/" .. decamelize(vim.fn.expand("<cword>")) .. "s.rb"
		if vim.fn.filereadable(filepath) == 1 then
			vim.cmd(":e " .. filepath)
		end
	elseif ft == "typescript" or ft == "javascript" then
		local filepath = "mirage/factories/" .. dasherize(decamelize(singularize(vim.fn.expand("<cword>")))) .. ".js"
		if vim.fn.filereadable(filepath) == 1 then
			vim.cmd(":e " .. filepath)
		end
	end
end, { desc = "[TELESCOPE] Go to factory" })

vim.keymap.set("n", "<leader>fh", function()
	builtin.help_tags()
end, { desc = "[TELESCOPE] Help tags" })

vim.keymap.set("n", ";;", function()
	builtin.resume()
end, { desc = "[TELESCOPE] Open last search" })

require("telescope").load_extension("file_browser")
local file_browser = require("telescope").extensions.file_browser
file_browser.hidden = true
vim.keymap.set("n", "<space>fd", function()
	file_browser.file_browser({ path = "%:p:h", select_buffer = true, respect_gitignore = false })
end, { desc = "[TELESCOPE] File browser" })
