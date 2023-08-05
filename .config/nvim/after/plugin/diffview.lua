vim.keymap.set("n", "<leader>gh", "::DiffviewFileHistory %<CR>", { desc = "[GIT] Diff view current file" })
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "[GIT] Diff view close" })
vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "[GIT] Diff view open" })