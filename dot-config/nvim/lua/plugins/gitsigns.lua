return {
	{
		"lewis6991/gitsigns.nvim",
		init = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "[GIT] Next hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "[GIT] Previous hunk" })

					-- Actions
					map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "[GIT] Stage hunk" })
					map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "[GIT] Reset hunk" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "[GIT] Stage buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[GIT] Undo stage hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "[GIT] Reset buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "[GIT] Preview hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "[GIT] Blame line" })
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "[GIT] Toggle blame line" })
					map("n", "<leader>hd", gs.diffthis, { desc = "[GIT] Diff this" })
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { desc = "[GIT] Diff this (cached)" })
					--map('n', '<leader>td', gs.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "[GIT] Select hunk" })

					vim.keymap.set({ "n", "v" }, "<leader>go", function()
						-- Batch git info in single call
						local git_info = vim.fn.systemlist(
							"git rev-parse --show-toplevel --abbrev-ref HEAD 2>/dev/null && git remote get-url origin 2>/dev/null"
						)
						if #git_info < 3 then
							print("Not a git repository or no remote origin")
							return
						end

						local repo_root = git_info[1]
						local branch = git_info[2]
						local remote_url = git_info[3]

						-- full path of current file
						local filepath = vim.fn.expand("%:p")

						-- path relative to git root
						local relpath = filepath:sub(#repo_root + 2) -- +2 for trailing "/"

						-- normalize GitHub URLs (SSH → HTTPS)
						remote_url = remote_url:gsub("^git@github.com:", "https://github.com/"):gsub("%.git$", "")

						-- handle detached HEAD
						if branch == "HEAD" then
							branch = vim.fn.systemlist("git rev-parse HEAD")[1]
						end

						-- check if branch exists on remote, fallback to main/master
						local remote_check = vim.fn.systemlist(
							"git ls-remote --heads origin " .. branch .. " 2>/dev/null"
						)
						if #remote_check == 0 or remote_check[1] == "" then
							local has_master = vim.fn.systemlist("git ls-remote --heads origin master 2>/dev/null")
							branch = (#has_master > 0 and has_master[1] ~= "") and "master" or "main"
						end

						-- build URL (single line or visual range)
						local url
						if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
							local start_line = vim.fn.line("v")
							local end_line = vim.fn.line(".")
							if start_line > end_line then
								start_line, end_line = end_line, start_line
							end
							url = string.format(
								"%s/blob/%s/%s#L%d-L%d",
								remote_url,
								branch,
								relpath,
								start_line,
								end_line
							)
						else
							local line = vim.fn.line(".")
							url = string.format("%s/blob/%s/%s#L%d", remote_url, branch, relpath, line)
						end

						-- open in browser (Linux/macOS/Windows)
						local opener = vim.fn.has("macunix") == 1 and "open"
							or (vim.fn.has("win32") == 1 and "start" or "xdg-open")

						vim.fn.jobstart({ opener, url }, { detach = true })
						print("Opening " .. url)
					end, { desc = "[GIT] Open on GitHub" })
				end,
			})
		end,
	},
}
