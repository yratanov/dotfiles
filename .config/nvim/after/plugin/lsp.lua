local lsp = require('lsp-zero').preset({
 manage_nvim_cmp = {
    set_sources = 'recommended',
    set_format = true
  }
})

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'tailwindcss',
  'ember',
  'rust_analyzer',
  'solargraph',
})

-- Fix Undefined global 'vim'
-- lsp.configure('lua-language-server', {
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { 'vim' }
--       }
--     }
--   }
-- })


local cmp_action = require('lsp-zero').cmp_action()
local lspkind = require('lspkind')

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/snippets" } })
lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})


require("lspsaga").setup({})


lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", '<cmd>Lspsaga goto_definition<CR>', opts)
  vim.keymap.set("n", "<leader>vf", '<Cmd>Lspsaga lsp_finder<CR>', opts)
  vim.keymap.set("n", "<leader>vd", '<Cmd>Lspsaga hover_doc<CR>', opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>ve", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>va", '<cmd>Lspsaga code_action<CR>', opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<c-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  mapping = {
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<Cr>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
  },
  preselect = 'item',
formatting = {
    format = lspkind.cmp_format(),
  },
})

