return {
	dir = "~/.config/nvim/lua/plugins/development_environment",
	dependencies = { "nvim-telescope/telescope.nvim" },
	lazy = false,
	config = function()
		local project_config = require("project_config")
		local simple_picker = require("simple_picker")
		local selected_mapping = project_config.get_project_config("development_environment")
		local all_mappings = {
			docker = "docker-compose exec web ",
			host = "",
		}

		local function assign_rails_mappings(prefix)
			vim.keymap.set(
				"n",
				"<Leader>rdm",
				":terminal " .. prefix .. "bundle exec rails db:migrate<CR>",
				{ noremap = true }
			)
			vim.keymap.set(
				"n",
				"<Leader>rdr",
				":terminal " .. prefix .. "bundle exec rails db:rollback<CR>",
				{ noremap = true }
			)
			vim.keymap.set(
				"n",
				"<Leader>rgr",
				":terminal " .. prefix .. "bundle exec rails g migration ",
				{ noremap = true }
			)
			vim.keymap.set(
				"n",
				"<Leader>rgm",
				":terminal " .. prefix .. "bundle exec rails g model ",
				{ noremap = true }
			)
			vim.keymap.set(
				"n",
				"<Leader>rgc",
				":terminal " .. prefix .. "bundle exec rails g controller ",
				{ noremap = true }
			)
		end

		if selected_mapping then
			local prefix = all_mappings[selected_mapping]
			assign_rails_mappings(prefix)
		end

		vim.api.nvim_create_user_command("SelectDevelopmentEnvironment", function()
			simple_picker.simple_piker(all_mappings, function(key, value)
				project_config.set_project_config("development_environment", key)
				assign_rails_mappings(value)
			end)
		end, {})
	end,
}
