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

			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			local storage_path = vim.fn.stdpath("data") .. "/TelescopeAlternatePickMappings.json"

			local function load_project_alternates()
				local f = io.open(storage_path, "r")
				if not f then
					return {}
				end
				local content = f:read("*a")
				f:close()
				return vim.fn.json_decode(content)
			end

			local function save_project_alternates(data)
				local f = io.open(storage_path, "w")
				if not f then
					return
				end
				f:write(vim.fn.json_encode(data))
				f:close()
			end

			local function get_project_id()
				return vim.fn.getcwd()
			end

			local function load_selected_key()
				local all_keys = load_project_alternates()
				return all_keys[get_project_id()]
			end

			local function save_selected_key(key)
				local all_keys = load_project_alternates()
				all_keys[get_project_id()] = key
				save_project_alternates(all_keys)
			end

			local function pick_alternate_mappings()
				local keys = {}
				for key, _ in pairs(all_mappings) do
					table.insert(keys, key)
				end

				pickers
					.new({}, {
						prompt_title = "",
						finder = finders.new_table({
							results = keys,
						}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, map)
							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()
								local key = selection[1]
								local value = all_mappings[key]
								save_selected_key(key)
								require("telescope-alternate").setup({
									mappings = value,
									presets = {},
								})
							end)
							return true
						end,
					})
					:find()
			end

			local key = load_selected_key()

			if key then
				require("telescope-alternate").setup({
					mappings = all_mappings[key],
					presets = {},
				})
			end

			vim.api.nvim_create_user_command("TelescopeAlternatePickMappings", pick_alternate_mappings, {})

			vim.keymap.set(
				"n",
				"<leader>ll",
				":Telescope telescope-alternate alternate_file<Cr>",
				{ desc = "[TELESCOPE] Alternate file" }
			)
		end,
	},
}
