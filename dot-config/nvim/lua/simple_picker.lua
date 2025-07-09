local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.simple_piker(options, callback)
	local keys = {}
	for key, _ in pairs(options) do
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
					local value = options[key]
          if callback then
            callback(key, value)
          end
				end)
				return true
			end,
		})
		:find()
end

return M
