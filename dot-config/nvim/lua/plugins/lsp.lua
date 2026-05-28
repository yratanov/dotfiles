return {
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"neovim/nvim-lspconfig",
		config = function()
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

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Lua LSP
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			}
			vim.lsp.enable("lua_ls")

			-- Ruby LSP (resolve path from project's mise ruby version)
			local function ruby_lsp_cmd()
				local handle = io.popen("mise where ruby 2>/dev/null")
				if handle then
					local ruby_dir = handle:read("*l")
					handle:close()
					if ruby_dir and ruby_dir ~= "" then
						return { ruby_dir .. "/bin/ruby-lsp" }
					end
				end
				return { "ruby-lsp" }
			end

			vim.lsp.config.ruby_lsp = {
				cmd = ruby_lsp_cmd(),
				capabilities = capabilities,
				filetypes = { "ruby", "eruby" },
				root_markers = { "Gemfile", ".git" },
			}
			vim.lsp.enable("ruby_lsp")

			-- Only start tailwindcss-language-server when it can actually function.
			-- The lspconfig default falls back to .git / Gemfile.lock-containing-"tailwind",
			-- which makes it attach in tailwindcss-rails projects that don't have the npm
			-- `tailwindcss` package installed, where it spins forever trying to resolve
			-- `tailwindcss/package.json`. Require either a JS-side config or an installed
			-- npm tailwindcss (v4 CSS-config setups need the npm package too).
			vim.lsp.config.tailwindcss = {
				capabilities = capabilities,
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local js_config = vim.fs.find({
						"tailwind.config.js",
						"tailwind.config.cjs",
						"tailwind.config.mjs",
						"tailwind.config.ts",
					}, { path = fname, upward = true })[1]
					if js_config then
						on_dir(vim.fs.dirname(js_config))
						return
					end
					local pkg = vim.fs.find(
						"node_modules/tailwindcss/package.json",
						{ path = fname, upward = true }
					)[1]
					if pkg then
						on_dir(vim.fs.dirname(pkg):gsub("/node_modules/tailwindcss$", ""))
					end
				end,
			}

			-- Enable other mason-installed servers
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("eslint")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("ember")
			vim.lsp.enable("rust_analyzer")
			vim.lsp.enable("emmet_ls")
			vim.lsp.enable("elixirls")
			vim.lsp.enable("clangd")
			vim.lsp.enable("gopls")

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
				Error = " ",
				Warn = " ",
				Hint = " ",
				Info = " ",
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
