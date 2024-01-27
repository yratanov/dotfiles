return {
	{ "onsails/lspkind-nvim" },
	{ "nvimtools/none-ls.nvim" },
	{ "ckipp01/stylua-nvim", build = "cargo install stylua" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
	},
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
				},
			})
			local nvim_lsp = require("lspconfig")
			nvim_lsp.tsserver.setup({})
			nvim_lsp.solargraph.setup({})
			nvim_lsp.ember.setup({})
			nvim_lsp.lua_ls.setup({})
			nvim_lsp.tailwindcss.setup({})

			require("luasnip.loaders.from_vscode").lazy_load({ exclude = { "ruby" } })
			require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/snippets" } })

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

					vim.keymap.set("n", "<leader>fo", function()
						vim.lsp.buf.format()
					end, { buffer = bufnr, remap = false, desc = "[LSP] Format" })

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

			-- lsp.set_sign_icons({
			--         error = "✘",
			--         warn = "▲",
			--         hint = "⚑",
			--         info = "»",
			-- })
			--
			vim.diagnostic.config({
				virtual_text = true,
			})

			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local ls = require("luasnip")

			vim.keymap.set({ "i" }, "<Tab>", function()
				if ls.expandable() then
					ls.expand()
				elseif ls.jumpable() then
					ls.jump(1)
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
				end
			end)

			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				ls.jump(-1)
			end, { silent = true })

			cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
				mapping = cmp.mapping.preset.insert({
					["<C-f>"] = function()
						ls.jump(1)
					end,
					["<C-b>"] = function()
						ls.jump(-1)
					end,
					["<C-e>"] = cmp.mapping.abort(),
					["<Cr>"] = cmp.mapping.confirm({ select = true }),
					-- ["<Tab>"] = cmp_action.luasnip_supertab(),
					["<C-Space>"] = cmp.mapping.complete(),
					-- ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
				},
				preselect = "item",
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				formatting = {
					format = lspkind.cmp_format(),
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})

			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettierd.with({
						filetypes = { "javascript", "typescript", "ruby", "handlebars", "json" },
					}),
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.erb_lint,
					null_ls.builtins.formatting.pg_format,
				},
			})
		end,
	},
}
