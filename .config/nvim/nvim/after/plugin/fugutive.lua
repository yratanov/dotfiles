vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gp", ':Git push')
vim.keymap.set("n", "<leader>gc", ':Git checkout')
vim.keymap.set("n", "<leader>gt", ':Git pull<CR>')
vim.keymap.set("n", "<leader>gj", '<cmd>diffget //2<CR>')
vim.keymap.set("n", "<leader>gf", '<cmd>diffget //3<CR>')

