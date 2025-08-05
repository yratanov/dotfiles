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
		else
			assign_rails_mappings("")
		end

		vim.api.nvim_create_user_command("SelectDevelopmentEnvironment", function()
			simple_picker.simple_piker(all_mappings, function(key, value)
				project_config.set_project_config("development_environment", key)
				assign_rails_mappings(value)
			end)
		end, {})

		function assign_deps_yard_auto_comment(project_name)
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				pattern = { "*.rb" },
				callback = function()
					local script = vim.fn.expand("~") .. "/.config/nvim/scripts/dry_auto_inject_to_yard.rb"
					local file_path = vim.fn.expand("%:p")
					local inflections = vim.fn.getcwd() .. "/config/initializers/inflections.rb"
					local deps = project_name .. "::Deps"
					vim.cmd("silent !" .. script .. " " .. file_path .. " " .. deps .. " " .. inflections)
				end,
				desc = "Auto inject yard doc",
			})
		end

		vim.api.nvim_create_user_command("SelectDepsYardAutocomment", function()
			local project_name = vim.fn.input("Enter project module name: ")
			project_config.set_project_config("project_module_name", project_name)
			assign_deps_yard_auto_comment(project_name)
		end, {})

		local project_name = project_config.get_project_config("project_module_name")

		if project_name then
			assign_deps_yard_auto_comment(project_name)
		end
	end,
}
