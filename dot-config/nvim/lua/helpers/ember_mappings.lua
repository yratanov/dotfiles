local M = {}

function M.get_ember_mappings()
	return {
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
end

return M
