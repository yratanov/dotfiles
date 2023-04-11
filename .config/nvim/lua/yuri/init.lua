require("yuri.remap")
require("yuri.set")

vim.cmd('au TextYankPost * silent! lua vim.highlight.on_yank()')
vim.g.filetype_thor = "ruby"
