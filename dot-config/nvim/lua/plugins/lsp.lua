return {
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"neovim/nvim-lspconfig",
		init = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"eslint",
					"tailwindcss",
					"ember",
					"rust_analyzer",
					"lua_ls",
					"emmet_ls",
					"elixirls",
					"arduino_language_server",
					"clangd",
					"gopls",
				},
			})
			local nvim_lsp = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			nvim_lsp.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			vim.lsp.enable("ruby_lsp")

			--
			-- get current folder ruby version with mise (mise can have ruby and node, we need only ruby)
			local handle = io.popen("mise current")
			local result = handle:read("*a")
			handle:close()

			local ruby_version = result:match("ruby (%d+%.%d+%.%d+)")
			if ruby_version == nil then
				ruby_version = "3.4.5" -- default to 3.4.5 if no version found
			end

			vim.lsp.config.ruby_lsp = {
				cmd = {
					os.getenv("HOME") .. "/.local/share/mise/installs/ruby/" .. ruby_version .. "/bin/ruby-lsp",
				},
				filetypes = { "ruby", "eruby" },
				root_markers = { "Gemfile", ".git", "." },
			}

			-- nvim_lsp.clangd.setup({
			-- 	cmd = { "clangd", "--background-index", "--clang-tidy" },
			-- 	root_dir = nvim_lsp.util.root_pattern("compile_commands.json", ".git"),
			-- })

			-- nvim_lsp.arduino_language_server.setup({
			-- 	cmd = {
			-- 		"arduino-language-server",
			-- 		"-cli",
			-- 		"/usr/bin/arduino-cli",
			-- 		"-clangd",
			-- 		"/usr/bin/clangd",
			-- 	},
			-- 	filetypes = { "arduino" },
			-- 	root_dir = nvim_lsp.util.root_pattern("*.ino", ".git"),
			-- 	settings = {},
			-- })
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
