return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			local telescope = require("telescope")
			local lga_actions = require("telescope-live-grep-args.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = "close",
							["<C-c>"] = false,
						},
					},
					-- 	preview = {
					-- 		treesitter = false,
					-- 	},
				},
				pickers = {
					find_files = {
						-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
				extensions = {
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
						-- define mappings, e.g.
						mappings = { -- extend mappings
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							},
						},
						-- ... also accepts theme settings, for example:
						-- theme = "dropdown", -- use dropdown theme
						-- theme = { }, -- use own theme spec
						-- layout_config = { mirror=true }, -- mirror preview pane
					},
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
				},
			})
			telescope.load_extension("live_grep_args")
			telescope.load_extension("fzf")
			local telescope_live_grep_args = require("telescope").extensions.live_grep_args

			local function dasherize(str)
				return (string.gsub(str, "%W+", "-"))
			end

			local function decamelize(str)
				return string.lower((string.gsub(str, "(%l)(%u)", "%1_%2")))
			end

			local function singularize(name)
				local irregulars = {}
				local out = name:gsub("(%w+)$", irregulars)
				if out ~= name then
					return out
				end
				out = name:gsub("[iI][eE]([sS])$", {
					s = "y",
					S = "Y",
				}):gsub("([oO])[eE][sS]$", "%1")
				if out:sub(-4, -1) == "sses" then
					out = out:gsub("([sS][sS])[eE][sS]$", "%1")
				else
					out = out:gsub("[sS]$", "")
				end
				return out
			end

			vim.keymap.set("n", "<leader>o", function()
				builtin.find_files({
					hidden = true,
					file_ignore_patterns = { "%.woff", "%.ttf", "%.eot", "%.png", "%.jpg", "%.jpeg", "%.gif", "%.pdf" },
				})
			end, { desc = "[TELESCOPE] Find files" })

			local function get_word_or_selection()
				local mode = vim.fn.mode()
				if mode:match("[vV]") then
					vim.cmd('noau normal! "vy"')
					local text = vim.fn.getreg("v")
					vim.fn.setreg("v", {})

					text = string.gsub(text, "\n", "")
					if #text > 0 then
						return text
					else
						return ""
					end
				else
					return vim.fn.expand("<cword>")
				end
			end

			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[TELESCOPE] Grep current word" })
			vim.keymap.set("v", "<leader>f", function()
				builtin.live_grep({ default_text = get_word_or_selection() })
			end, { desc = "[TELESCOPE] Grep current word" })
			vim.keymap.set(
				"n",
				"<leader>f/",
				builtin.current_buffer_fuzzy_find,
				{ desc = "[TELESCOPE] Find current buffer" }
			)
			vim.keymap.set("n", "<leader>fi", builtin.search_history, { desc = "[TELESCOPE] Search history" })

			vim.keymap.set("n", "<leader>ff", telescope_live_grep_args.live_grep_args, { desc = "[TELESCOPE] Grep" })

			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[TELESCOPE] Keymaps" })

			vim.keymap.set("n", "<leader>e", function()
				builtin.oldfiles({ only_cwd = true })
			end, { desc = "[TELESCOPE] Prev files" })

			vim.keymap.set("n", "<leader>b", builtin.git_branches, { desc = "[TELESCOPE] Git branches" })

			vim.keymap.set("n", "<leader>fs", builtin.git_stash, { desc = "[TELESCOPE] Git stashes" })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[TELESCOPE] Git changes" })
			vim.keymap.set("n", "<leader>gb", function()
				local previewers = require("telescope.previewers")
				local pickers = require("telescope.pickers")
				local sorters = require("telescope.sorters")
				local finders = require("telescope.finders")

				pickers
					.new({
						results_title = "Modified on current branch",
						finder = finders.new_oneshot_job({
							"git",
							"diff",
							"--name-only",
							"--diff-filter=ACMR",
							"--relative",
							"master",
						}),
						sorter = sorters.get_fuzzy_file(),
						previewer = previewers.new_termopen_previewer({
							get_command = function(entry)
								return {
									"git",
									"diff",
									"--diff-filter=ACMR",
									"--relative",
									"master",
									entry.value,
								}
							end,
						}),
					})
					:find()
			end, { desc = "[TELESCOPE] Git branch modified" })

			local function get_lib_root()
				local ft = vim.bo.filetype

				if ft == "ruby" then
					local handle = io.popen("ruby -e 'print Gem.default_dir' 2>/dev/null")
					if handle then
						local dir = handle:read("*a")
						handle:close()
						if dir and dir ~= "" then
							return dir .. "/gems"
						end
					end
				elseif ft:match("javascript") or ft:match("typescript") then
					local node_modules = vim.fn.finddir("node_modules", ".;")
					if node_modules ~= "" then
						return node_modules
					end
				end

				return nil
			end

			-- 🔹 Search files in libraries
			local function search_lib_files()
				local lib_root = get_lib_root()
				if not lib_root or vim.fn.isdirectory(lib_root) == 0 then
					print("No library directory found for " .. vim.bo.filetype)
					return
				end

				builtin.find_files({
					prompt_title = "Library files (" .. vim.bo.filetype .. ")",
					cwd = lib_root,
					hidden = true,
				})
			end

			-- 🔹 Search text in libraries
			local function search_lib_text()
				local lib_root = get_lib_root()
				if not lib_root or vim.fn.isdirectory(lib_root) == 0 then
					print("No library directory found for " .. vim.bo.filetype)
					return
				end

				builtin.live_grep({
					prompt_title = "Library text search (" .. vim.bo.filetype .. ")",
					cwd = lib_root,
					default_text = get_word_or_selection(),
				})
			end

			vim.keymap.set("n", "<leader>fl", search_lib_files, { desc = "Search in libraries" })
			vim.keymap.set({ "n", "v" }, "<leader>fL", search_lib_text, { desc = "Search text in libraries" })

			vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "[TELESCOPE] LSP references" })

			vim.keymap.set("n", "<leader>gm", function()
				local buf = vim.api.nvim_get_current_buf()
				local ft = vim.bo[buf].filetype
				if ft == "ruby" then
					local filepath = "app/models/" .. singularize(vim.fn.expand("<cword>")) .. ".rb"
					if vim.fn.filereadable(filepath) == 1 then
						vim.cmd(":e " .. filepath)
					end
				elseif ft == "typescript" or ft == "javascript" then
					local filepath = "app/models/"
						.. dasherize(decamelize(singularize(vim.fn.expand("<cword>"))))
						.. ".ts"
					if vim.fn.filereadable(filepath) == 1 then
						vim.cmd(":e " .. filepath)
					end
				end
			end, { desc = "[TELESCOPE] Open model file" })

			vim.keymap.set("n", "<leader>fc", function()
				builtin.find_files({ search_file = dasherize(decamelize(vim.fn.expand("<cword>"))) })
			end, { desc = "[TELESCOPE] Find file by current word" })

			vim.keymap.set("n", "<leader>gf", function()
				local buf = vim.api.nvim_get_current_buf()
				local ft = vim.bo[buf].filetype
				if ft == "ruby" then
					local filepath = "spec/factories/" .. decamelize(vim.fn.expand("<cword>")) .. "s.rb"
					if vim.fn.filereadable(filepath) == 1 then
						vim.cmd(":e " .. filepath)
					end
				elseif ft == "typescript" or ft == "javascript" then
					local filepath = "mirage/factories/"
						.. dasherize(decamelize(singularize(vim.fn.expand("<cword>"))))
						.. ".js"
					if vim.fn.filereadable(filepath) == 1 then
						vim.cmd(":e " .. filepath)
					end
				end
			end, { desc = "[TELESCOPE] Go to factory" })

			vim.keymap.set("n", "<leader>fh", function()
				builtin.help_tags()
			end, { desc = "[TELESCOPE] Help tags" })

			vim.keymap.set("n", "fl", function()
				builtin.resume()
			end, { desc = "[TELESCOPE] Open last search" })

			vim.keymap.set("n", "<C-p>", function()
				require("telescope").extensions.neoclip.default()
			end, { desc = "[TELESCOPE] Clipboard history" })

			require("telescope").load_extension("file_browser")
			local file_browser = require("telescope").extensions.file_browser
			file_browser.hidden = true
			vim.keymap.set("n", "<space>fd", function()
				file_browser.file_browser({
					path = "%:p:h",
					select_buffer = true,
					hide_parent_dir = true,
					respect_gitignore = false,
				})
			end, { desc = "[TELESCOPE] File browser" })
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	"nvim-telescope/telescope-live-grep-args.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
