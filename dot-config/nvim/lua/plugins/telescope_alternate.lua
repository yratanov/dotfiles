return {
	{
		"otavioschwanck/telescope-alternate",
		init = function()
			local ruby_mappings = require("helpers.ruby_mappings")

			local ruby_api_mappings = ruby_mappings.get_rails_api_mappings()
			local ruby_fs_mappings = ruby_mappings.get_rails_full_stack_mappings()
			local ember_mappings = require("helpers.ember_mappings").get_ember_mappings()

			local all_mappings = {
				ruby_api = ruby_api_mappings,
				ruby_fs = ruby_fs_mappings,
				ember = ember_mappings,
			}

			local project_config = require("project_config")
			local simple_picker = require("simple_picker")

			local selected_mapping = project_config.get_project_config("telescope_alternate_pick_mappings")

			if selected_mapping then
				require("telescope-alternate").setup({
					mappings = all_mappings[selected_mapping],
					presets = {},
				})
			end

			vim.api.nvim_create_user_command("TelescopeAlternatePickMappings", function()
				simple_picker.simple_piker(all_mappings, function(key, value)
					project_config.set_project_config("telescope_alternate_pick_mappings", key)
					require("telescope-alternate").setup({
						mappings = value,
						presets = {},
					})
				end)
			end, {})

			vim.keymap.set(
				"n",
				"<leader>ll",
				":Telescope telescope-alternate alternate_file<Cr>",
				{ desc = "[TELESCOPE] Alternate file" }
			)
		end,
	},
}
