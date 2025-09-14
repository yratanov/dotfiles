return {
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	init = function()
	-- 		require("catppuccin").setup({
	-- 			flavour = "mocha", -- latte, frappe, macchiato, mocha
	-- 			background = { -- :h background
	-- 				light = "mocha",
	-- 				dark = "mocha",
	-- 			},
	-- 			transparent_background = true, -- disables setting the background color.
	-- 			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
	-- 			term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
	-- 			dim_inactive = {
	-- 				enabled = false, -- dims the background color of inactive window
	-- 				shade = "dark",
	-- 				percentage = 0.15, -- percentage of the shade to apply to the inactive window
	-- 			},
	-- 			float = {
	-- 				transparent = true, -- enable transparent floating windows
	-- 				solid = false, -- use solid styling for floating windows, see |winborder|
	-- 			},
	-- 			no_italic = false, -- Force no italic
	-- 			no_bold = false, -- Force no bold
	-- 			no_underline = false, -- Force no underline
	-- 			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
	-- 				comments = { "italic" }, -- Change the style of comments
	-- 				conditionals = { "italic" },
	-- 				loops = {},
	-- 				functions = {},
	-- 				keywords = {},
	-- 				strings = {},
	-- 				variables = {},
	-- 				numbers = {},
	-- 				booleans = {},
	-- 				properties = {},
	-- 				types = {},
	-- 				operators = {},
	-- 			},
	-- 			color_overrides = {},
	-- 			custom_highlights = {},
	-- 			telescope = {
	-- 				enabled = true, -- enable telescope integration
	-- 			},
	-- 			integrations = {
	-- 				cmp = true,
	-- 				gitsigns = true,
	-- 				telescope = true,
	-- 				nvimtree = true,
	-- 				treesitter = true,
	-- 				notify = false,
	-- 				mini = false,
	-- 				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
	-- 			},
	-- 		})
	--
	-- 		-- setup must be called before loading
	-- 		vim.cmd.colorscheme("catppuccin")
	--
	-- 		vim.cmd([[highlight IndentBlanklineIndent1 guifg=#454957 gui=nocombine]])
	-- 	end,
	-- },
	{
		"neanias/everforest-nvim",
		priority = 1000,
		init = function()
			require("everforest").setup({
				background = "hard",
				transparent_background_level = 90,
				italics = true,
				disable_italic_comments = false,
				inlay_hints_background = "dimmed",
				on_highlights = function(hl, _)
					hl["@string.special.symbol.ruby"] = { link = "@field" }
				end,
			})
			vim.cmd("colorscheme everforest")
		end,
	},
}
