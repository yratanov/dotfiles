return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fo",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		-- Everything in opts will be passed to setup()
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				ruby = { "prettierd" },
				eruby = { "erb_format" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				handlebars = { "prettierd" },
				css = { "prettierd" },
				json = { "prettierd" },
			},
			formatters = {
				prettier = {
					condition = false,
				},
			},
			-- Set up format-on-save
			format_on_save = true,
		},
	}
}
