local Util = require("util")

return {
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		opts = {
			actions = {
				change_dir = {
					enable = false
				},
				open_file = {
					quit_on_open = true
				},
			},
			filters = {
				dotfiles = false
			},
			git = {
				ignore = false
			},
			view = {
				width = 50
			}
		},
		keys = {
			{
				"<leader>fe",
				function ()
					require("nvim-tree.api").tree.toggle()
				end,
				mode = { "n", "v" }
			}
		}
	},

	-- Fuzzy finder.
	-- The default key bindings to find files will use Telescope's
	-- `find_files` or `git_files` depending on whether the
	-- directory is a git repo.
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		lazy = true,
		version = false, -- telescope did only one release, so use HEAD for now
		keys = {
			{ "<leader>/", Util.telescope("live_grep", { cwd = false }), desc = "Grep (root dir)", mode = { "n", "v" } },
			{ "<leader>?", Util.telescope("live_grep"), desc = "Grep (cwd)", mode = { "n", "v" } },
			{ "<leader>:", Util.telescope("command_history"), desc = "Command History", mode = { "n", "v" } },
			-- find
			{ "<leader>fb", Util.telescope("buffers"), desc = "Buffers", mode = { "n", "v" } },
			{ "<leader>fF", Util.telescope("files"), desc = "Find Files (cwd)", mode = { "n", "v" } },
			{ "<leader>ff", Util.telescope("files", { cwd = false }), desc = "Find Files (root dir)", mode = { "n", "v"} },
			{ "<leader>fr", Util.telescope("oldfiles"), desc = "Recent", mode = { "n", "v" } },
			-- git
			{ "<leader>gc", Util.telescope("git_commits"), desc = "commits" },
			{ "<leader>gs", Util.telescope("git_status"), desc = "status" },
			-- search
			{ "<leader>b/", Util.telescope("current_buffer_fuzzy_find"), desc = "Buffer", mode = { "n", "v" } },
			-- tags
			{ "<leader>bt", Util.telescope("current_buffer_tags"), desc = "buffer tags", mode = { "n", "v" } },
			{ "<leader>ft", Util.telescope("tags"), desc = "tags", mode = { "n", "v" } },
			{ "<leader>sd", Util.telescope("diagnostics", { bufnr = 0 }), desc = "File diagnostics" },
			{ "<leader>sD", Util.telescope("diagnostics"), desc = "Workspace diagnostics" },
			{
				"<leader>ss",
				Util.telescope("lsp_document_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
						"Enum",
						"Constant",
					},
				}),
				desc = "Goto Symbol",
				mode  = { "n", "v" }
			},
			{
				"<leader>sS",
				Util.telescope("lsp_dynamic_workspace_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
						"Enum",
						"Constant"
					}
				}),
				desc = "Goto Symbol (Workspace)",
				mode = { "n", "v" }
			}
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					mappings = {
						i = {
							["<CR>"] = actions.select_default + actions.center,
						},
					},
				},
			})
		end
	},

	-- git signs highlights text that has changed since the list
	-- git commit, and also lets you interactively stage & unstage
	-- hunks in a commit.
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true
	},

	-- Automatically highlights other instances of the word under your cursor.
	-- This works with LSP, Treesitter, and regexp matching to find the other
	-- instances.
	{
		"RRethy/vim-illuminate",
		event = "BufEnter",
		opts = {
			providers = { "regex" },
			delay = 0
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end
	},

	-- Finds and lists all of the TODO, HACK, BUG, etc comment
	-- in your project and loads them into a browsable list.
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
		opts = {
			gui_sytle = {
				fg = "none",
				bg = "none"
			},
			highlight = {
				keyword = "bg",
				after = "",
				before = "",
				pattern = [[.*<(KEYWORDS)\s*:?]],
			},
			search = {
				pattern = [[\b(KEYWORDS)\b]]
			}
		}
	},

	{
		"mbbill/undotree",
		keys = {
			{
				"<leader>u",
				function()
					vim.cmd.UndotreeToggle()
					vim.cmd.UndotreeFocus()
				end,
				mode = { "n", "v" }
			}
		}
	},

	{
		"telescope.nvim",
		dependencies = {
			{
				"aznhe21/actions-preview.nvim",
				opts = {
					diff = {
						ctxlen = 1000
					},
					backend = {
						"telescope"
					},
					telescope = {
						layout_strategy = "horizontal",
						layout_config = {
							prompt_position = "bottom",
							preview_cutoff = 0,
						}
					}
				},
				keys = {
					{
						"<leader>fm",
						function() require("actions-preview").code_actions() end,
						mode = { "n", "v"}
					}
				}
			}
		}
	},

	{
		"ludovicchabant/vim-gutentags"
	},

	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function() vim.fn["mkdp#util#install"]() end,
		keys = {
			{
				"<leader>md",
				vim.cmd.MarkdownPreview
			}
		}
	},

	{
		"kylechui/nvim-surround",
		tags = "*",
		config = true,
		event = "InsertEnter",
	},

	{
		"gelguy/wilder.nvim",
		dependencies = {
			"romgrk/fzy-lua-native"
		},
		build = "UpdateRemotePlugins",
		event = "CmdlineEnter",
		config = function()
			local wilder = require("wilder")
			wilder.setup({ modes = { ":", "/", "?" } })

			wilder.set_option("pipeline", {
				wilder.branch(
					wilder.python_file_finder_pipeline({
						file_command = function(_, arg)
							if string.find(arg, ".") ~= nil then
								return { "fdfind", "-tf", "-H" }
							else
								return { "fdfind", "-tf" }
							end
						end,
						dir_command = { "fd", "-td" },
						filters = { "cpsm_filter" }
					}),
					wilder.substitute_pipeline({
						pipeline = wilder.python_search_pipeline({
							skip_cmdtype_check = 1,
							pattern = wilder.python_fuzzy_pattern({
								start_at_boundary = 0
							})
						})
					}),
					wilder.cmdline_pipeline({
						fuzzy = 2,
						fuzzy_filter = wilder.lua_fzy_filter()
					}),
					{
						wilder.check(function(_, x) return x == "" end),
						wilder.history()
					},
					wilder.python_search_pipeline({
						pattern = wilder.python_fuzzy_pattern({
							start_at_boundary = 0
						})
					})
				)
			})

			local highlighters = {
				wilder.pcre2_highlighter(),
				wilder.basic_highlighter()
			}

			local popupmenu_border_theme = wilder.popupmenu_renderer(
				wilder.popupmenu_border_theme({
					border = "rounded",
					empty_message = wilder.popupmenu_empty_message_with_spinner(),
					highlighter = highlighters,
					left = {
						wilder.popupmenu_devicons(),
						wilder.popupmenu_buffer_flags({
							flags = " a + ",
							icons = { ["+"] = "", a = "", h = "" }
						})
					},
					max_height = 10
				})
			)

			local wildmenu_rendered = wilder.wildmenu_renderer({
				highlighter = highlighters
			})

			wilder.set_option("renderer", wilder.renderer_mux({
				[":"] = popupmenu_border_theme,
				["/"] = wildmenu_rendered
			}))
		end
	},

	{
		"rootkiter/vim-hexedit",
		keys = {
			{
				"<leader>xx",
				vim.cmd.Hexedit
			},
			{
				"<leader>xs",
				":Hexsearch "
			}
		}
	},

	{
		"andweeb/presence.nvim",
		lazy = false,
		event = "BufEnter",
		config = true,
		opts = {
			neovim_image_text = "The only true text editor (beside ed)",
			-- blacklist = { ".*" }
		}
	},

	{
		"Eandrju/cellular-automaton.nvim",
		config = function()
			local rotate_animation = {
				name = "rotate",
				fps = 10,
				delta_th = math.pi / 30  -- Step angle
			}

			local initial_grid
			local nrows  -- #rows
			local h_nrows  -- floor(#rows / 2)
			local ncols  -- #columns
			local h_ncols  -- floor(#columns / 2)
			local th  -- Actual angle of rotation

			rotate_animation.init = function(grid)
				initial_grid = vim.deepcopy(grid)
				nrows = #initial_grid
				h_nrows = math.floor(nrows / 2)
				ncols = #initial_grid[1]
				h_ncols = math.floor(ncols / 2)
				th = 0
			end

			local round = function(x)
				return math.ceil(x + 0.5)
			end

			rotate_animation.update = function(grid)
				-- Update th
				th = th + rotate_animation.delta_th
				if th >= math.pi * 2 then
					th = th - math.pi * 2
				end
				-- Reset grid, we always rotate the initial grid
				for i=1,nrows do
					for j=1,ncols do
						grid[i][j] = { char = " " }
					end
				end

				for i=1,nrows do
					for j=1,ncols do
						-- Offset because the center is not in the upper left corner
						local y = i - h_nrows
						local x = j - h_ncols
						-- Quick maths
						local ny = round(x * math.sin(th) + y * math.cos(th))
						local nx = round(x * math.cos(th) - y * math.sin(th))
						-- Revert the offset
						local ni = ny + h_nrows
						local nj = nx + h_ncols
						if (0 < ni and ni <= nrows and 0 < nj and nj <= ncols) then
							grid[ni][nj] = initial_grid[i][j]
						end
					end
				end

				return true
			end

			require("cellular-automaton").register_animation(rotate_animation)
		end,
		keys = {
			{
				"<leader>mir",
				function() require("cellular-automaton").start_animation("make_it_rain") end
			},
			{
				"<leader>rot",
				function() require("cellular-automaton").start_animation("rotate") end
			},
			{
				"<leader>gol",
				function() require("cellular-automaton").start_animation("game_of_life") end
			}
		}
	},

	{ "LunarVim/bigfile.nvim" }
}
