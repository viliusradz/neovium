return {
	{ "nvim-telescope/telescope.nvim",
		-- keys can be set here, but they have been moved to [config] file
		opts = function()
			local actions = require("telescope.actions")

			local open_with_trouble = function(...)
				return require("trouble.sources.telescope").open(...)
			end
			-- find_files_no_ignore
			-- find_files_with_hidden

			local function find_command()
				if 1 == vim.fn.executable("rg") then
					return  { "rg", "--files", "--color", "never", "-g", "!.git" }
				elseif 1 == vim.fn.executable("fd") then
					return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("fdfind") then
					return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("find") then
					return { "find", ".", "-type", "f" }
				elseif 1 == ivm.fn.executable("where") then
					return { "where", "/r", ".", "*" }
				end
			end

			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					-- open files in the first window that is  an actual file.
					-- use the current window if no other window is avail
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<c-t>"] = open_with_trouble,
							["<a-t>"] = open_with_trouble,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up
						},
						n = {
							["q"] = actions.close,
						}
					}
				},
				pickers = {
					find_files = {
						find_command = find_command,
						hidden = true
					}
				},
				extensions = {
					['ui-select'] = { require('telescope.themes').get_dropdown() },
					fzf = {
						fuzzy = true, 
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					}
				}
			}
		end
	},
	{ "nvim-lua/plenary.nvim",
		lazy = true
	},

	{ "nvim-telescope/telescope-fzf-native.nvim",
		build =(build_cmd ~= cmake) and "make"
			or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install",
		-- enabled = build_cmd ~= nil,
	},
	{ "nvim-telescope/telescope-ui-select.nvim", },
}
