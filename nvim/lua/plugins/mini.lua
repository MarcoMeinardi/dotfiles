return {
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		version = false
	},

	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			mappings = {
				comment = "<leader>c",
				comment_line = "<leader>c",
				comment_visual = "<leader>c"
			},
			options = {
				ignore_blank_line = true
			}
		}
	},

	{
		"echasnovski/mini.move",
		event = "VeryLazy",
		config = true
	},

	-- Active indent guide and indent text objects. When you're browsing
	-- code, this highlights the current level of indentation, and animates
	-- the highlighting.
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			symbol = "▏",
			options = { try_as_border = true },
			draw = { delay = 0 }
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end
			})
		end
	},

	{
		"echasnovski/mini.jump",
		event = "VeryLazy",
		config = function()
			require("mini.jump").setup({
				delay = {
					highlight = 0
				}
			})
			vim.api.nvim_set_hl(0, "MiniJump", { bold = true, fg = "none", bg = "none" })
		end
	}
}
