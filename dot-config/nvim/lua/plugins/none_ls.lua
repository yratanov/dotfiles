return {
	{ "ckipp01/stylua-nvim", build = "cargo install stylua" },
	{
		"nvimtools/none-ls.nvim",
		init = function()
			local null_ls = require("null-ls")
			local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettierd.with({
						filetypes = {
							"javascript",
							"typescript",
							"typescriptreact",
							"ruby",
							"handlebars",
							"json",
						},
					}),
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.erb_format,
					null_ls.builtins.formatting.pg_format,
					null_ls.builtins.formatting.gofmt,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.keymap.set("n", "<Leader>fo", function()
							vim.lsp.buf.format({
								bufnr = vim.api.nvim_get_current_buf(),
								filter = function(cl)
									-- By default, ignore any formatters provider by other LSPs
									-- (such as those managed via lspconfig or mason)
									return cl.name == "null-ls"
								end,
							})
						end, { buffer = bufnr, desc = "[lsp] format" })

						vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
						-- vim.api.nvim_create_autocmd("BufWritePre", {
						-- 	group = group,
						-- 	buffer = bufnr,
						-- 	callback = function()
						-- 		vim.lsp.buf.format({
						-- 			bufnr = vim.api.nvim_get_current_buf(),
						-- 			filter = function(cl)
						-- 				-- By default, ignore any formatters provider by other LSPs
						-- 				-- (such as those managed via lspconfig or mason)
						-- 				return cl.name == "null-ls"
						-- 			end,
						-- 		})
						-- 	end,
						-- })
					end
				end,
			})
		end,
	},
}
