function ColorMyPencils(color, variant)
	color = color or "rose-pine"
	variant = variant or "main"
	a = "a"
	require("rose-pine").setup({
		--- @usage 'auto'|'main'|'moon'|'dawn'
		variant = variant,
		--- @usage 'main'|'moon'|'dawn'
		dark_variant = "main",
		bold_vert_split = false,
		dim_nc_background = false,
		disable_background = false,
		disable_float_background = false,
		disable_italics = false,

		--- @usage string hex value or named color from rosepinetheme.com/palette
		groups = {
			background = "base",
			background_nc = "_experimental_nc",
			panel = "surface",
			panel_nc = "base",
			border = "highlight_med",
			comment = "muted",
			link = "iris",
			punctuation = "subtle",

			error = "love",
			hint = "iris",
			info = "foam",
			warn = "gold",

			headings = {
				h1 = "iris",
				h2 = "foam",
				h3 = "rose",
				h4 = "gold",
				h5 = "pine",
				h6 = "foam",
			},
			-- or set all headings at once
			-- headings = 'subtle'
		},

		-- Change specific vim highlight groups
		-- https://github.com/rose-pine/neovim/wiki/Recipes
		highlight_groups = {
			-- ColorColumn = { bg = "rose" },

			-- Blend colours against the "base" background
			CursorLine = { bg = "foam", blend = 10 },
			StatusLine = { fg = "love", bg = "love", blend = 10 },

			TelescopeBorder = { fg = "highlight_high", bg = "none" },
			TelescopeNormal = { bg = "none" },
			TelescopePromptNormal = { bg = "base" },
			TelescopeResultsNormal = { fg = "subtle", bg = "none" },
			TelescopeSelection = { fg = "text", bg = "base" },
			TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
			NeotestDir = { fg = "iris" },
			NeotestFile = { fg = "iris" },
			NeotestFocused = { fg = "rose" },
			NeotestNamespace = { fg = "gold" },
			NeotestRunning = { fg = "gold" },
			NeotestFailed = { fg = "love" },
			NeotestPassed = { fg = "foam" },
			NeotestTarget = { fg = "foam" },
			NeotestTest = { fg = "gold" },
		},
	})

	vim.cmd("colorscheme rose-pine")

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
