local lsp = require("lsp-zero").preset({
	manage_nvim_cmp = {
		set_sources = "recommended",
	},
})

lsp.ensure_installed({
	"tsserver",
	"eslint",
	"tailwindcss",
	"ember",
	"rust_analyzer",
	"solargraph",
})

local cmp_action = require("lsp-zero").cmp_action()
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/snippets" } })
require("lspsaga").setup({})

local nvim_lsp = require("lspconfig")

nvim_lsp.solargraph.setup({
	cmd = { os.getenv("HOME") .. "/.rbenv/shims/solargraph", "stdio" },
	--   root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git", "."),
	useBundler = true,
	filetypes = { "ruby", "thor", "rake", "Gemfile" },
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
	vim.keymap.set("n", "<leader>vf", "<Cmd>Lspsaga lsp_finder<CR>", opts)
	vim.keymap.set("n", "<leader>vd", "<Cmd>Lspsaga hover_doc<CR>", opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vh", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>va", "<cmd>Lspsaga code_action<CR>", opts)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<c-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end)

lsp.format_mapping("<leader>ff", {
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["null-ls"] = { "javascript", "typescript", "lua", "ruby" },
	},
})

lsp.format_on_save({
	format_opts = {
		timeout_ms = 10000,
	},
	servers = {
		["null-ls"] = { "javascript", "typescript", "lua", "ruby" },
	},
})

lsp.setup({})

lsp.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})
--
vim.diagnostic.config({
	virtual_text = true,
})

local cmp = require("cmp")

cmp.setup({
	mapping = {
		["<C-f>"] = cmp_action.luasnip_jump_forward(),
		["<C-b>"] = cmp_action.luasnip_jump_backward(),
		["<Cr>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp_action.luasnip_supertab(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
	},
	preselect = "item",
	formatting = {
		format = lspkind.cmp_format(),
	},
})

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettierd.with({
			filetypes = { "javascript", "typescript", "ruby" },
		}),
		null_ls.builtins.formatting.stylua,
	},
})
