local builtin = require("telescope.builtin")

local function dasherize(str)
	return (string.gsub(str, "%W+", "-"))
end

local function decamelize(str)
	return string.lower((string.gsub(str, "(%l)(%u)", "%1_%2")))
end

vim.keymap.set("n", "<leader>o", function()
	builtin.find_files({ hidden = true })
end, { desc = "[TELESCOPE] Find files" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[TELESCOPE] Grep current word" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[TELESCOPE] Grep" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[TELESCOPE] Keymaps" })
vim.keymap.set("n", "<leader>e", function()
	builtin.oldfiles({ only_cwd = true })
end, { desc = "[TELESCOPE] Prev files" })
vim.keymap.set("n", "<leader>fb", builtin.git_branches, { desc = "[TELESCOPE] Git branches" })
vim.keymap.set("n", "<leader>fs", builtin.git_stash, { desc = "[TELESCOPE] Git stashes" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "[TELESCOPE] LSP references" })
vim.keymap.set("n", "<leader>fc", function()
	builtin.find_files({ search_file = dasherize(decamelize(vim.fn.expand("<cword>"))) })
end, { desc = "[TELESCOPE] Find file by current word" })

vim.keymap.set("n", "<leader>gf", function()
	vim.cmd(":e spec/factories/" .. decamelize(vim.fn.expand("<cword>")) .. "s.rb")
end, { desc = "[TELESCOPE] Go to ruby factory" })
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
