local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local rails = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "rails",
			finder = finders.new_table({
				results = { "db:migrate", "db:rollback", "g migration", "g model", "g controller" },
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local terminal_command = "bundle exec rails " .. selection[1]
					if selection[1]:sub(0, 1) == "g" then
						vim.ui.input({ prompt = "ARGS: " }, function(args)
							if args then
								vim.cmd(":terminal " .. terminal_command .. " " .. args)
							end
						end)
					else
						vim.cmd("terminal " .. terminal_command)
					end
				end)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>ra", function()
	rails(require("telescope.themes").get_dropdown({}))
end, { desc = "[TELESCOPE] Rails commands" })
