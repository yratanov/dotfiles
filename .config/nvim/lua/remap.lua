vim.g.mapleader = " "
vim.g.nowrap = true
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- vim.keymap.set("n", "J", "5j")
-- vim.keymap.set("n", "K", "5k")
-- vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "''", "\"+yi'", { desc = "Yank content betwee ' ' to system clipboard" })

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>Q", ":qa<CR>")
vim.keymap.set("n", "<leader>w", ":wa<CR>")
vim.keymap.set("n", "<leader>W", ":wq<CR>")

-- vim.keymap.set("n", "gf", "<C-w>gF", { noremap = true })
vim.keymap.set("v", "<leader>gi", "g<C-a>", { noremap = true, desc = "Increment numbers" })

vim.keymap.set("n", "<Leader>m", ':call mkdir(expand("%:p:h"), "p")<CR>', { noremap = true, desc = "Create directory" })

vim.keymap.set(
	"n",
	"<leader>rr",
	":silent !bundle exec rubocop -a %<CR>",
	{ noremap = true, desc = "Rubocop auto-correct" }
)

-- vim.keymap.set("n", "<C-J>", "<C-w>j", { noremap = true })
-- vim.keymap.set("n", "<C-K>", "<C-w>k", { noremap = true })
-- vim.keymap.set("n", "<C-L>", "<C-w>l", { noremap = true })
-- vim.keymap.set("n", "<C-H>", "<C-w>h", { noremap = true })
--
vim.keymap.set("n", "<C-]>", ":cn<Cr>")
vim.keymap.set("n", "<C-[>", ":cN<Cr>")
vim.keymap.set("n", "ga", "gg<S-v>G")
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

vim.keymap.set("n", "<Leader>rab", ":%bd|e#", { noremap = true, desc = "Remove all buffers except current" })

vim.keymap.set("n", "<Leader><Leader>", "<C-^>", { noremap = true, desc = "Switch between last two buffers" })

vim.keymap.set("n", "<Leader>cp", ':let @+ = expand("%")<cr>', { noremap = true, desc = "Copy current file path" })

vim.keymap.set("n", "<Leader>rdm", ":terminal bundle exec rails db:migrate<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>rdr", ":terminal bundle exec rails db:rollback<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>rgr", ":terminal bundle exec rails g migration ", { noremap = true })
vim.keymap.set("n", "<Leader>rgm", ":terminal bundle exec rails g model ", { noremap = true })
vim.keymap.set("n", "<Leader>rgc", ":terminal bundle exec rails g controller ", { noremap = true })
vim.keymap.set("n", "<Leader>rge", ":terminal ember g ", { noremap = true })

vim.keymap.set("n", "<Leader>gqa", ":terminal ~/.config/nvim/scripts/git_merge_current_to_qa.sh", { noremap = true })

vim.keymap.set("n", "<Leader>gjt", ":%!sh ~/.config/scripts/jira-from-branch.sh<CR>", { noremap = true, silent = true })

-- Copy/Paste JIRA ticket number
vim.keymap.set("n", "<Leader>tp", "/PL<CR>yt/ggpA ")
