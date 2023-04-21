require("yuri.remap")
require("yuri.set")
require("yuri.open_from_clipboard")
require("yuri.auto_inject_yard")

vim.cmd('au TextYankPost * silent! lua vim.highlight.on_yank()')


