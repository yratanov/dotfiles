return {
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"neovim/nvim-lspconfig",
		init = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"tsserver",
					"eslint",
					"tailwindcss",
					"ember",
					"rust_analyzer",
					"lua_ls",
					"solargraph",
					"emmet_ls",
				},
			})
			local nvim_lsp = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			nvim_lsp.tsserver.setup({})
			nvim_lsp.solargraph.setup({})
			nvim_lsp.ember.setup({})
			nvim_lsp.lua_ls.setup({})
			nvim_lsp.tailwindcss.setup({})
			nvim_lsp.eslint.setup({})

			nvim_lsp.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local bufnr = ev.buf
					local opts = { buffer = bufnr, remap = false }

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set(
						"n",
						"gs",
						vim.lsp.buf.references,
						{ buffer = bufnr, remap = false, desc = "[LSP] Finder" }
					)

					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.type_definition,
						{ buffer = bufnr, remap = false, desc = "[LSP] Hover doc" }
					)
					vim.keymap.set(
						{ "n", "v" },
						"<leader>va",
						vim.lsp.buf.code_action,
						{ buffer = bufnr, remap = false, desc = "[LSP] Code actions" }
					)
					vim.keymap.set("n", "<leader>vws", function()
						vim.lsp.buf.workspace_symbol()
					end, { buffer = bufnr, remap = false, desc = "[LSP] Workspace symbol" })
					vim.keymap.set("n", "<leader>vh", function()
						vim.diagnostic.open_float()
					end, { buffer = bufnr, remap = false, desc = "[LSP] Open float" })

					vim.keymap.set("n", "[d", function()
						vim.diagnostic.goto_next()
					end, { buffer = bufnr, remap = false, desc = "[LSP] Goto next" })

					vim.keymap.set("n", "]d", function()
						vim.diagnostic.goto_prev()
					end, { buffer = bufnr, remap = false, desc = "[LSP] Goto prev" })

					vim.keymap.set("n", "<leader>ve", function()
						vim.lsp.buf.references()
					end, { buffer = bufnr, remap = false, desc = "[LSP] References" })

					vim.keymap.set("n", "gr", function()
						vim.lsp.buf.rename()
					end, { buffer = bufnr, remap = false, desc = "[LSP] Rename" })

					vim.keymap.set("i", "<c-h>", function()
						vim.lsp.buf.signature_help()
					end, { buffer = bufnr, remap = false, desc = "[LSP] Signature help" })

					vim.keymap.set("n", "<leader>vo", function()
						vim.lsp.buf.execute_command({
							command = "_typescript.organizeImports",
							arguments = { vim.fn.expand("%:p") },
						})
					end, { buffer = bufnr, remap = false, desc = "[LSP] Organize imports" })
				end,
			})

			local signs = {
				Error = " ",
				Warn = " ",
				Hint = " ",
				Info = " ",
			}

			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
			vim.diagnostic.config({
				virtual_text = true,
			})
		end,
	},
}
