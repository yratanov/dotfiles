local builtin = require('telescope.builtin')

local function dasherize(str)
  return (string.gsub(str, '%W+', '-'))
end

local function decamelize(str)
  return string.lower((string.gsub(str, '(%l)(%u)', '%1_%2')))
end


vim.keymap.set('n', '<leader>o', function()
  builtin.find_files({ hidden = true })
end)
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>e', function()
  builtin.oldfiles({ only_cwd = true })
end, {})
vim.keymap.set('n', '<leader>fb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>fs', builtin.git_stash, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fc', function()
  builtin.find_files({ search_file = dasherize(decamelize(vim.fn.expand("<cword>"))) })
end)

vim.keymap.set('n', '<leader>gf', function()
  vim.cmd(':e spec/factories/' .. decamelize(vim.fn.expand("<cword>")) .. 's.rb')
end)
vim.keymap.set('n', '<leader>fh', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
require("telescope").load_extension "file_browser"
local file_browser = require "telescope".extensions.file_browser
file_browser.hidden = true
vim.keymap.set('n', '<space>fd', function() file_browser.file_browser({ path = "%:p:h", select_buffer = true }) end)

