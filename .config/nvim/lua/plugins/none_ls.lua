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
						filetypes = { "javascript", "typescript", "ruby", "handlebars", "json" },
					}),
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.erb_lint,
					null_ls.builtins.formatting.pg_format,
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

						-- format on save
						-- vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
						-- vim.api.nvim_create_autocmd(event, {
						-- 	buffer = bufnr,
						-- 	group = group,
						-- 	callback = function()
						-- 		vim.lsp.buf.format({ bufnr = bufnr, async = async })
						-- 	end,
						-- 	desc = "[lsp] format on save",
						-- })
						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = group,
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format()
								end,
							})
						end
					end

					if client.supports_method("textDocument/rangeFormatting") then
						vim.keymap.set("x", "<Leader>f", function()
							vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
						end, { buffer = bufnr, desc = "[lsp] format" })
					end
				end,
			})
		end,
	},
}
