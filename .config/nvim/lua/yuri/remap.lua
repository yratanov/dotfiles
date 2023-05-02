vim.g.mapleader = " "
vim.g.nowrap = true
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "J", "5j")
vim.keymap.set("n", "K", "5k")
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>Q", ":qa<CR>")
vim.keymap.set("n", "<leader>w", ":wa<CR>")
vim.keymap.set("n", "<leader>W", ":wq<CR>")

vim.keymap.set("n", "gf", "<C-w>gF", { noremap = true })
vim.keymap.set("v", "<leader>gi", "g<C-a>", { noremap = true })

vim.keymap.set("n", "<Leader>m", ':call mkdir(expand("%:p:h"), "p")<CR>', { noremap = true })

vim.keymap.set("n", "<leader>rr", ":silent !bundle exec rubocop -a %<CR>", { noremap = true })

vim.keymap.set("n", "<C-J>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-K>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-L>", "<C-w>l", { noremap = true })
vim.keymap.set("n", "<C-H>", "<C-w>h", { noremap = true })

vim.keymap.set("n", "<Leader><Leader>", "<C-^>", { noremap = true })

vim.keymap.set("n", "<Leader>cp", ':let @+ = expand("%")<cr>', { noremap = true })
