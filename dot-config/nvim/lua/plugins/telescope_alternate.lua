return {
	{
		"otavioschwanck/telescope-alternate",
		init = function()
			local function mergeArrays(a, b)
				local z = {}
				local n = 0
				for _, v in ipairs(a) do
					n = n + 1
					z[n] = v
				end
				for _, v in ipairs(b) do
					n = n + 1
					z[n] = v
				end
				return z
			end

			local function in_table(tbl, item)
				for key, value in pairs(tbl) do
					if value == item then
						return key
					end
				end
				return false
			end

			--
			-- TELESCOPE ALTERNATE
			--

			local function append_project_root(paths)
				local project_root = vim.fn.expand("$HOME/projects")
				local new_paths = {}
				for _, path in ipairs(paths) do
					table.insert(new_paths, project_root .. "/" .. path)
				end
				return new_paths
			end

			local ruby_api_projects = append_project_root({ "pulse-app/api" })
			local ruby_fs_projects = append_project_root({ "satchel-thrive", "workout_bro" })
			local ember_projects = append_project_root({ "pulse-app/frontend" })

			local ruby_mappings = {}

			local function generate_spec_mapping(base_path, mapping)
				return {
					{
						base_path .. "/" .. mapping .. "/(.*).rb",
						{
							{ "spec/" .. mapping .. "/[1]_spec.rb", "Test", true },
						},
					},
					{
						"spec/" .. mapping .. "/(.*)_spec.rb",
						{
							{ base_path .. "/" .. mapping .. "/[1].rb", "Model", true },
						},
					},
				}
			end

			for _, mapping in ipairs({
				"models",
				"serializers",
				"policies",
				"jobs",
				"helpers",
			}) do
				ruby_mappings = mergeArrays(ruby_mappings, generate_spec_mapping("app", mapping))
			end

			for _, mapping in ipairs({ "request", "service" }) do
				ruby_mappings = mergeArrays(ruby_mappings, generate_spec_mapping("lib", mapping))
			end

			local ruby_api_mappings = mergeArrays({
				{
					"app/controllers(.*)/(.*)_controller.rb",
					{
						{ "app/models/[2:singularize].rb", "Model" },
						{ "app/serializers/[2:singularize]_serializer.rb", "Serializer", true },
						{ "spec/controllers[1]/[2]_controller_spec.rb", "Test", true },
					},
				},
				{
					"spec/controllers(.*)/(.*)_spec.rb",
					{
						{ "app/controllers[1]/[2].rb", "Controller" },
					},
				},
				{
					"app/mailers(.*)/(.*)_mailer.rb",
					{
						{ "app/views/[1][2]_mailer/*.html.erb", "View", true },
						{ "spec/mailers[1]/[2]_mailer_spec.rb", "Test", true },
					},
				},
				{
					"spec/mailers(.*)/(.*)_spec.rb",
					{
						{ "app/mailers[1]/[2].rb", "Mailer" },
					},
				},
				{
					"app/views/(.*)/(.*).html.(.*)",
					{
						{ "app/controllers/**/*[1]_controller.rb", "Controller" },
						{ "app/mailers/**/*[1].rb", "Mailer" },
						{ "app/models/[1:singularize].rb", "Model" },
						{ "app/helpers/**/*[1]_helper.rb", "Helper" },
					},
				},
				{
					"lib/tasks/(.*).thor",
					{
						{ "spec/tasks/[1]_spec.rb", "Test", true },
					},
				},
				{
					"lib/tasks/(.*).rake",
					{
						{ "spec/tasks/[1]_spec.rb", "Test", true },
					},
				},
				{
					"spec/tasks/(.*)_spec.rb",
					{
						{ "lib/tasks/[1].rake", "Rake", true },
						{ "lib/tasks/[1].thor", "THOR", true },
					},
				},
			}, ruby_mappings)

			local ruby_fs_mappings = mergeArrays({
				{
					"app/controllers(.*)/(.*)_controller.rb",
					{
						{ "app/models/[2:singularize].rb", "Model" },
						{ "app/views/[1][2]/*.html.erb", "View" },
						{ "app/helpers/**/*[2]_helper.rb", "Helper" },
						{ "app/serializers/[2:singularize]_serializer.rb", "Serializer", true },
						{ "spec/controllers[1]/[2]_controller_spec.rb", "Test", true },
						{ "spec/requests[1]/[2]_spec.rb", "Request", true },
						{ "app/views[1]/[2]/*.turbo_stream.erb", "TS View", true },
						{ "app/views[1]/[2]/*.html.erb", "View", true },
					},
				},
				{
					"app/services/(.*).rb",
					{
						{ "spec/services/[1]_spec.rb", "Test", true },
					},
				},
				{
					"spec/services/(.*)_spec.rb",
					{
						{ "app/services/[1].rb", "Service", true },
					},
				},
				{
					"app/components(.*)/(.*)_component.rb",
					{
						{ "app/components[1]/[2]_component.html.erb", "View" },
						{ "app/components[1]/[2]_component_controller.js", "JS" },
					},
				},
				{
					"app/components(.*)/(.*)_component.html.erb",
					{
						{ "app/components[1]/[2]_component.rb", "Component" },
						{ "app/components[1]/[2]_component_controller.js", "JS" },
					},
				},
				{
					"app/components(.*)/(.*)_component_controller.js",
					{
						{ "app/components[1]/[2]_component.rb", "Component" },
						{ "app/components[1]/[2]_component.html.erb", "View" },
					},
				},
				{
					"spec/controllers(.*)/(.*)_spec.rb",
					{
						{ "app/controllers[1]/[2].rb", "Controller" },
					},
				},
				{
					"app/mailers(.*)/(.*)_mailer.rb",
					{
						{ "app/views/[1][2]_mailer/*.html.erb", "View", true },
						{ "spec/mailers[1]/[2]_mailer_spec.rb", "Test", true },
					},
				},
				{
					"spec/mailers(.*)/(.*)_spec.rb",
					{
						{ "app/mailers[1]/[2].rb", "Mailer" },
					},
				},
				{
					"app/views/(.*)/(.*).html.(.*)",
					{
						{ "app/controllers/**/*[1]_controller.rb", "Controller" },
						{ "app/mailers/**/*[1].rb", "Mailer" },
						{ "app/models/[1:singularize].rb", "Model" },
						{ "app/helpers/**/*[1]_helper.rb", "Helper" },
					},
				},
				{
					"app/views/(.*)/(.*).turbo_stream.(.*)",
					{
						{ "app/controllers/**/*[1]_controller.rb", "Controller" },
					},
				},
				{
					"lib/tasks/(.*).thor",
					{
						{ "spec/tasks/[1]_spec.rb", "Test", true },
					},
				},
				{
					"lib/tasks/(.*).rake",
					{
						{ "spec/tasks/[1]_spec.rb", "Test", true },
					},
				},
				{
					"spec/tasks/(.*)_spec.rb",
					{
						{ "lib/tasks/[1].rake", "Rake", true },
						{ "lib/tasks/[1].thor", "THOR", true },
					},
				},
			}, ruby_mappings)

			local ember_mappings = {
				{
					"app/components/(.*).hbs",
					{
						{ "tests/integration/components/[1]-test.js", "Component test", true },
						{ "app/components/[1].js", "Component JS", true },
						{ "app/components/[1].ts", "Component TS", true },
						{ "tests/helpers/page/components/[1]-component.js", "Page", true },
					},
				},
				{
					"app/components/(.*).[jt]s$",
					{
						{ "app/components/[1].hbs", "Component HBS", true },
						{ "tests/helpers/page/components/[1]-component.js", "Page", true },
						{ "tests/integration/components/[1]-test.js", "Component test", true },
					},
				},
				{
					"tests/helpers/page/components/(.*)-component.js",
					{
						{ "app/components/[1].hbs", "Component HBS", true },
						{ "app/components/[1].js", "Component JS", true },
						{ "app/components/[1].ts", "Component TS", true },
					},
				},
				{
					"tests/integration/components/(.*)-test.js",
					{
						{ "app/components/[1].hbs", "Component HBS" },
						{ "app/components/[1].js", "Component JS", true },
						{ "app/components/[1].ts", "Component TS", true },
					},
				},
				{
					"app/routes/(.*).[jt]s$",
					{
						{ "app/controllers/[1].js", "Controller JS", true },
						{ "app/controllers/[1].ts", "Controller TS", true },
						{ "app/templates/[1].hbs", "Template", true },
					},
				},
				{
					"app/controllers/(.*).[jt]s$",
					{
						{ "app/routes/[1].js", "Route JS", true },
						{ "app/routes/[1].ts", "Route TS", true },
						{ "app/templates/[1].hbs", "Template", true },
					},
				},
				{
					"app/templates/(.*).hbs",
					{
						{ "app/routes/[1].js", "Route JS", true },
						{ "app/routes/[1].ts", "Route TS", true },
						{ "app/controllers/[1].js", "Controller JS", true },
						{ "app/controllers/[1].ts", "Controller TS", true },
					},
				},
			}

			local selected_mappings = {}

			if in_table(ruby_api_projects, vim.fn.getcwd()) then
				selected_mappings = ruby_api_mappings
			elseif in_table(ruby_fs_projects, vim.fn.getcwd()) then
				selected_mappings = ruby_fs_mappings
			elseif in_table(ember_projects, vim.fn.getcwd()) then
				selected_mappings = ember_mappings
			end

			require("telescope-alternate").setup({
				mappings = selected_mappings,
				presets = {}, -- Telescope pre-defined mapping presets
			})

			vim.keymap.set(
				"n",
				"<leader>ll",
				":Telescope telescope-alternate alternate_file<Cr>",
				{ desc = "[TELESCOPE] Alternate file" }
			)
		end,
	},
}
