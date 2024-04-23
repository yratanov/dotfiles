-- Auto completion and code snippets
return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
			},
		},
		init = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load({ exclude = { "ruby" } })
			require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/snippets" } })

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
						ls.lsp_expand(args.body)
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
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
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
		end,
	},
}
