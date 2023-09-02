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

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/snippets" } })

local nvim_lsp = require("lspconfig")

nvim_lsp.solargraph.setup({
	cmd = { os.getenv("HOME") .. "/.rbenv/shims/solargraph", "stdio" },
	--   root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git", "."),
	filetypes = { "ruby", "thor", "rake", "Gemfile" },
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)

	vim.keymap.set("n", "gs", "<Cmd>Lspsaga lsp_finder<CR>", { buffer = bufnr, remap = false, desc = "[LSP] Finder" })

	vim.keymap.set("n", "gi", "<Cmd>Lspsaga hover_doc<CR>", { buffer = bufnr, remap = false, desc = "[LSP] Hover doc" })

	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, { buffer = bufnr, remap = false, desc = "[LSP] Workspace symbol" })
	vim.keymap.set("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
	vim.keymap.set("n", "<leader>vh", function()
		vim.diagnostic.open_float()
	end, { buffer = bufnr, remap = false, desc = "[LSP] Open float" })

	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, { buffer = bufnr, remap = false, desc = "[LSP] Goto next" })

	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, { buffer = bufnr, remap = false, desc = "[LSP] Goto prev" })

	vim.keymap.set(
		"n",
		"<leader>va",
		"<cmd>Lspsaga code_action<CR>",
		{ buffer = bufnr, remap = false, desc = "[LSP] Code action" }
	)
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
		vim.lsp.buf.execute_command({ command = "_typescript.organizeImports", arguments = { vim.fn.expand("%:p") } })
	end, { buffer = bufnr, remap = false, desc = "[LSP] Organize imports" })
end)

lsp.format_mapping("<leader>fo", {
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["null-ls"] = { "javascript", "typescript", "lua", "ruby", "handlebars", "json", "sql", "erb", "eruby" },
	},
})

lsp.format_on_save({
	format_opts = {
		timeout_ms = 10000,
	},
	servers = {
		["null-ls"] = { "javascript", "typescript", "lua", "ruby", "handlebars", "json" },
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
local cmp_action = require("lsp-zero").cmp_action()
local lspkind = require("lspkind")
local ls = require("luasnip")

-- nvim_lsp.emmet_ls.setup({
-- 	filetypes = { "handlebars", "html" },
-- })
--
vim.keymap.set({ "i" }, "<Tab>", function()
	if ls.expand_or_jumpable() then
		ls.expand()
	else
		ls.jump(1)
	end
end)
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	ls.jump(-1)
end, { silent = true })

cmp.setup({
	mapping = {
		["<C-f>"] = cmp_action.luasnip_jump_forward(),
		["<C-b>"] = cmp_action.luasnip_jump_backward(),
		["<C-e>"] = cmp.mapping.abort(),
		["<Cr>"] = cmp.mapping.confirm({ select = true }),
		-- ["<Tab>"] = cmp_action.luasnip_supertab(),
		["<C-Space>"] = cmp.mapping.complete(),
		-- ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
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
